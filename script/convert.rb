require 'bundler/setup'
Bundler.require

TARGETDIR = Pathname.new('./img').freeze
FILENAME = Pathname.new("./docs/maclane/categories_for_the_working_mathematicians.pdf").freeze

DROPBOX_URL = 'https://content.dropboxapi.com'.freeze
UPLOAD_PATH = '/2/files/upload'.freeze
DROPBOX_DIR = Pathname.new('/Pictures/notes').freeze

FileUtils.mkdir_p(TARGETDIR)

puts 'Converting PDF into images...'

begin
  images = Magick::Image.read(FILENAME) do
    self.format = 'PDF'
    self.quality = 100
    self.density = 192
  end.each_with_index do |image, i|
    image_name = TARGETDIR / "#{File.basename(FILENAME, '.pdf')}_#{i + 1}.png"
    image.write image_name
    puts "Created #{image_name}!"
  end

  puts 'Finished converting PDF into images.'
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
              dropbox_api_arg: %({"path": "#{DROPBOX_DIR / f}", "mode": "overwrite", "autorename": false, "mute": true})
    puts "Uploaded #{TARGETDIR / f}!"
  end

  puts 'Finished uploading images.'

  FileUtils.rm_r(TARGETDIR, secure: true)
rescue => e
  puts "Aborted! Something bad happend: #{e}"
  FileUtils.rm_r(TARGETDIR, secure: true)
end
