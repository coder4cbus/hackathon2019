class String 

	def sentences
		self.gsub(/\n|\r/, ' ').split(/\.\s*/)
	end

	def words
		self.scan(/\w[\w\'\-]*/)
	end

end

class Wordplay

	def self.switch_pronouns(text)
		text.gsub(/\b(I am|you are|I|You|Me|Your|My)\b/i) do |pronoun|
			case pronoun.downcase
			         when "i"
				       "you"
               when "you"
               	   "me"
               when "me"
                   "you"
                when "i am"
                    "you are"
                when "you are"
                	 "i am"
                when "your"
                   "me"
                when "me"
                    "your"
        end
    end.sub(/^me\b/i,'i')
  end


       def self.best_senteces(sentences , desired_words)
       	ranked_sentences = sentences.sort_by do |s|
       		s.words.length - (s.downcase.words - desired_words).length
       	end

       	ranked_sentences.last
       end
  end


