class PhoneBook
    def initialize
        @people_unlisted = [] #redo the initialization w a 2d array
        @people_listed = {}
    end

    def add(name, number, is_listed)
        if number.length == 12
            check = true
        end
        if !(number =~ /^\d{3}-\d{3}-\d{4}$/)
            return false
        end
        new_p = Person.new(name, number, is_listed)
        if @people_listed.has_key?(name)
            @people_unlisted.push(new_p)
        else
            @people_unlisted = {name => new_p}
        end
        true
    end

    def lookup(name)
        if @people_listed.has_key?(name)
            return @people_listed[name]
        else
            return nil
    end

    def lookupByNum(number)
       @people_listed.key(Person.number) #may or may not work
    end

    def namesByAc(areacode)
        ans = []
        for i in 0..(@people_unlisted.length - 1)
            if @people_unlisted[i][0..2] == areacode[0..2]
                ans.push(@people_unlisted[i].name)
            end
        end
        @people_listed.each do |key, value|
            if value.number[0..2] == areacode[0..2]
                ans.push(key)
            end
        end
        ans
    end

    def is_digit?(s)
        ascii = s.ord
        ascii >= 48 && ascii <= 57
    end
end

class Person
    def initialize(name, number, is_listed)
        @name = name
        @number = number
        @is_listed = is_listed
    end

    def to_s
        @name + " " + @number + @is_listed.to_s
    end
end
end