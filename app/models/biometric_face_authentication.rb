require 'net/http'
require 'av_capture'

class BiometricFaceAuthentication

	def get_headshot(filename)
		# Create a recording session
		session = AVCapture::Session.new

		# Find the first video capable device
		dev = AVCapture.devices.find(&:video?)

		# Connect the camera to the recording session
		session.run_with(dev) do |connection|
		  f = File.new("loginimage/#{filename}.jpg","w")
		   f.write "#{connection.capture}"
		   f.close
		  # # Capture an image and write it to local file "photo.jpg"
		  #  f.write "#{connection.capture}"
	     end
	  end 


	  def store_img(filename)
		AWS::S3::Base.establish_connection!(
		  :access_key_id => ENV[ACCESS_KEY_ID]
		  :secret_access_key => ENV[SECRET_ACCESS_KEY]
		)

		file = "loginimage/#{filename}.jpg"
		bucket = "damesbond"
	    status=AWS::S3::S3Object.store(File.basename(file), open(file), bucket, :access => :public_read)
	    FileUtils.rm_rf(Dir.glob('loginimage/*'))
	 return image_url = AWS::S3::S3Object.url_for(File.basename(file), bucket)[/[^?]+/]

    end

	def request_post(method,username)
		get_headshot("#{username}")
		store_img("#{username}")
		uri= URI("https://ea8i5cz5t1.execute-api.us-east-2.amazonaws.com/Test?uname=/#{uid}")
	    http = Net::HTTP.new(uri.host, uri.port)
	    request = Net::HTTP::Post.new(uri.request_uri)
	    response = http.request(request)
	    puts response
	end


   def request_put(useroldname,usernewname)
	    uri= URI("http://localhost:4567//api/profile/edit/minkbot/123/#{useroldname}/#{usernewname}")
	    http = Net::HTTP.new(uri.host, uri.port)
	    request = Net::HTTP::Put.new(uri.path)
	    response = http.request(request)
	    
	end

	def request_delete(username)
	    uri= URI("https://ea8i5cz5t1.execute-api.us-east-2.amazonaws.com/Test?uname=/#{username}")
	    http = Net::HTTP.new(uri.host, uri.port)
	    request = Net::HTTP::Delete.new(uri.request_uri)
	    response = http.request(request)
	end

    def register(username)
	  request_post("registration","#{username}")
	end

	def authorise(username)
		request_post("authorise","#{username}")
    end

    def edit(useroldname,usernewname)
		request_put("#{useroldname}","#{usernewname}")
    end

    def delete(username)
    	request_delete("#{username}")
    end
end

