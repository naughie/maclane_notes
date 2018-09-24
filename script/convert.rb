require 'bundler/setup'
Bundler.require

TARGETDIR = Pathname.new('./img').freeze
SOURCEDIR = Pathname.new('./docs/maclane').freeze

DROPBOX_URL = 'https://content.dropboxapi.com'.freeze
UPLOAD_PATH = '/2/files/upload'.freeze
DROPBOX_DIR = Pathname.new('/Pictures/notes').freeze

FileUtils.mkdir_p(TARGETDIR)

def conv filename
  puts "Converting #{filename} into images..."

  images = Magick::Image.read(filename) do
    self.format = 'PDF'
    self.quality = 100
    self.density = 216
  end.each_with_index do |image, i|
    image_name = TARGETDIR / "#{File.basename(filename, '.pdf')}_#{i + 1}.png"
    image.paint_transparent('white', 1, true).write image_name
    puts "Created #{image_name}!"
  end

  puts "Finished converting #{filename} into images."
rescue => e
  puts "Aborted! Something bad happend: #{e}"
end

def upload
  puts 'Uploading images to Dropbox...'
  conn = Faraday.new(url: DROPBOX_URL) do |faraday|
    faraday.request :url_encoded
    faraday.response :json
    faraday.adapter Faraday.default_adapter
  end

  images = Dir.entries(TARGETDIR).select { |f| f.end_with? '.png' }
  images.each do |f|
    conn.post UPLOAD_PATH,
              File.read(TARGETDIR / f),
              authorization: "Bearer #{ENV['DROPBOX_ACCESS_TOKEN']}",
              content_type: 'application/octet-stream',
              dropbox_api_arg: %({"path": "#{DROPBOX_DIR / "maclane_chapter#{f}"}", "mode": "overwrite", "autorename": false, "mute": true})
    puts "Uploaded #{TARGETDIR / "maclane_chapter#{f}"}!"
  end

  puts 'Finished uploading images.'
rescue => e
  puts "Aborted! Something bad happend: #{e}"
end

ARGV.each { |f| conv SOURCEDIR / "#{f}.pdf" }
upload

FileUtils.rm_r(TARGETDIR, secure: true)
