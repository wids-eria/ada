require 'progressbar'
require 'json'
require 'csv'

class Student
  attr_accessor :user

  def initialize(user)
    self.user = user 
  end
  
  def run csv
    
    #find all the kode entries
    kode_logs = user.data.where(key: 'Kode', schema: '1.3.9.0')
    revision_count = Hash.new
    if kode_logs.count > 0
      kode_logs.each do |log|
        kode = log.kode['kode']
        actor = kode['actorName']
        if revision_count[actor] == nil
          revision_count[actor] = 0 
        else
          revision_count[actor] = revision_count[actor] + 1
        end
        csv << [user.player_name, Time.at(log.timestamp.gsub(/[^0-9]/, '')[0..-4].to_i), kode['levelId'], actor, revision_count[actor], kode['pages'].count]
      end

      #puts user.player_name + " successfully parsed!"
    end
  
  end

end

class AnalyizeKode

  def run name, students
    #bar = ProgressBar.new 'students', students.count
    csv = CSV.open("csv/kodu/"+name+".csv", "w") 
    csv << ['player name', 'timestamp', 'Level Id', 'actor name', 'revision count', 'page count']
    students.each do |student_name|
      user = User.where(["lower(player_name) = :login", login: student_name.first.downcase]).first
      if user != nil
        Student.new(user).run csv
      else
        puts student_name.first + " NOT FOUND"
      end
      #bar.inc
    end
    csv.close

  end


end

sparta = CSV.open("csv/kodu/sections/sparta.csv", 'r')
peagle = CSV.open("csv/kodu/sections/peagle.csv", 'r')
glacialD = CSV.open("csv/kodu/sections/glacialD.csv", 'r')
waunakee = CSV.open("csv/kodu/sections/waunakee.csv", 'r')
AnalyizeKode.new.run 'Sparta_kode_parsed', sparta
AnalyizeKode.new.run 'palmyra-eagle_kode_parsed', peagle
AnalyizeKode.new.run 'glacial_drummlin_kode_parsed', glacialD
AnalyizeKode.new.run 'waunakee_kode_parsed', waunakee 
