require 'telegram/bot'
require 'open-uri'
token = '231613241:AAFk3CUaP6NxsIOZHBeABlt-TEEsFSKOY6I'
Telegram::Bot::Client.run(token) do |bot|
  dem = 0
  soTiNhan = 0
  bot.listen do |message|
  	stringfull = message.text
  	dem = dem +1
    if stringfull.is_a? String
    	stringCommand = stringfull[0..5]
    	thamSo1 = stringfull[7..19]
      if(stringCommand == '/hello')
        bot.api.send_message(chat_id: message.chat.id, text: "Em chào anh ❤ #{thamSo1} ❤ đẹp zai")
      end
      if(stringfull[0..8] == '/weather')
        begin
           require "unirest"
            require 'rubygems'
            require "json"
            response = Unirest.get "http://api.openweathermap.org/data/2.5/weather", 
                        headers:{ "Accept" => "application/json" },
                        parameters:{"q"=>"Hanoi,vi","units"=>"metric","appid"=> "3db343bc59bf3c48d204390df39aa14f"}
           a = response.body # Parsed body
          nhietdo = a["main"]["temp"].to_s
          thoitiet = "Thời tiết thủ đô Hà Nội hiện tại  🇻🇳\n" << "🌡Nhiệt độ: "<< nhietdo  <<" °C\n" << "⚡ Tình trạng: "<< a["weather"][0]["main"]
           bot.api.send_message(chat_id: message.chat.id, text: "#{thoitiet}")
        rescue Exception => e
           bot.api.send_message(chat_id: message.chat.id, text: "#{e.message}")
        else
          # other exception
        ensure
          # always executed
        end
       
      end
      if(stringfull[0..6] == '/search')
      begin
	      require "unirest"
        require 'rubygems'
        require "json"
        keyword = stringfull[8..40]
        response = Unirest.post "http://learn-tlit.rhcloud.com/sinhvien.php", 
                                headers:{ "Accept" => "application/json" },
                                parameters:{"name"=>"#{keyword}"}
        a= response.body
        i = 0
        str = ""
        while i < a.length do
         b = "🔸#{a[i]['name']} - 🔹#{a[i]['mobile']} - 🔹#{a[i]['khoa']}\n" 
          str += b
          i += 1
          if i == a.length
            break
          end
        end
        bot.api.send_message(chat_id: message.chat.id, text: "🔎10 kết quả tìm kiếm đầu tiên\n\n#{str}")
      rescue Exception => e
      	bot.api.send_message(chat_id: message.chat.id, text: "Không tìm thấy kết quả hoặc xảy ra lỗi 👻")

      end
        
      end
      
      if(stringfull[0..2] == '/ts')
      begin
	      require "unirest"
        require 'rubygems'
        require "json"
        keyword = stringfull[4..40]
        response = Unirest.post "http://learn-tlit.rhcloud.com/search_region.php.php", 
                                headers:{ "Accept" => "application/json" },
                                parameters:{"term1"=>"#{keyword}"}
        a= response.body
        i = 0
        str = ""
        while i < a.length do
         b = "🔸#{a[i]['maTruong']} - 🔹#{a[i]['tenTruong']}\n" 
          str += b
          i += 1
          if i == a.length
            break
          end
        end
        bot.api.send_message(chat_id: message.chat.id, text: "🔎10 kết quả tìm kiếm đầu tiên\n\n#{str}")
      rescue Exception => e
      	bot.api.send_message(chat_id: message.chat.id, text: "Không tìm thấy kết quả hoặc xảy ra lỗi 👻")

      end
        
      end
      
      if(stringfull[0..4] == '/ping')
        bot.api.send_message(chat_id: message.chat.id, text: "~Pong: @#{message.from.username} 🐰")
      end
      if(stringfull[0..4] == '/info')
        bot.api.send_message(chat_id: message.chat.id, text: 
          "
          ⏱ Số đoạn chat đã gửi #{dem}   \n 📢 Số tin nhắn đã gửi: #{soTiNhan}")
          
      end
      if(stringfull[0..4] == '/list')
        # bot.api.send_message(chat_id: message.chat.id, text: "⚒ Danh sách số điện thoại ⚒ \n
        # 👤 Hoài Nam       📞 0943767467
        # 👤 Đức Thắng      📞 0967953735
        # 👤 Kiên TI26    676447987") 
        require 'twilio-ruby'

        # Get your Account Sid and Auth Token from twilio.com/user/account
        account_sid = 'AC101e7cd905bb5d4537ce6eca3f4759c0'
        auth_token = 'e925f8292a701f336c7f07ab176c76a1'
        @client = Twilio::REST::Client.new account_sid, auth_token
        mobile = ""
        # Loop over caller_ids and print out a property for each one
        @client.account.outgoing_caller_ids.list.each do |caller_id|
            a ="👤 " << caller_id.friendly_name << "            📞"  << caller_id.phone_number << "\n"
            mobile += a
        end
        bot.api.send_message(chat_id: message.chat.id, text: "⚒ Danh sách số điện thoại ⚒ \n\n#{mobile}")
      end
      if (stringfull[0..3] == '/sms')
        begin
        
          require 'twilio-ruby' 
        # put your own credentials here 
        account_sid = 'AC101e7cd905bb5d4537ce6eca3f4759c0' 
        auth_token = 'e925f8292a701f336c7f07ab176c76a1'
        # set up a client to talk to the Twilio REST API 
        @client = Twilio::REST::Client.new account_sid, auth_token 
        @client.account.messages.create({
        :from => "+18443520786", 
        :to => "+84#{stringfull[6..15]}", 
        :body => "#{stringfull[16..200]}",  
        }) 
        bot.api.send_message(chat_id: message.chat.id, text: "
          SMS gửi tới ➡️ 0#{stringfull[6..15]} \n  💌 Nội dung \n \"#{stringfull[16..200]}\"")
          soTiNhan = soTiNhan + 1
        rescue Exception => e
          bot.api.send_message(chat_id: message.chat.id, text: "~Lỗi cú pháp nhắn tin rồi!!👻
          Cú pháp /sms 09... noidung")
        end
      end
      if (stringfull[0..5] == '/photo')
        # if(masinhvien.is_a? String || masinhvien > 28280 || masinhvien <10000 || masinhvien.length == nil)
        #   bot.api.send_message(chat_id: message.chat.id, text: "Bạn: @#{message.from.username} làm cái nồi gì vậy?? 👻")
        # else
            begin
            masinhvien = stringfull[8..12]
            open('image.png', 'wb') do |file|
                file << open("http://daotaotructuyen.thanglong.edu.vn/tlu-custom/image.php?studentId=A#{masinhvien}").read
            end
            bot.api.send_photo(chat_id: message.chat.id, photo: Faraday::UploadIO.new('image.png', 'image/jpeg'), caption:"#{stringfull[7..12]}")
            rescue Exception => e
              bot.api.send_message(chat_id: message.chat.id, text: "Bạn: @#{message.from.username} làm cái nồi gì vậy?? 👻 . Xin hãy nhập đúng cú pháp dùm")
            end
        # end 
      end
    end
  end
end
