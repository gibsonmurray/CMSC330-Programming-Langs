class PhoneBook
    def initialize
        @people_unlisted = []
        @people_listed = {}
    end

    def add(name, number, is_listed)
        if number.length == 12
            check = true
            for i in 0..(number.length - 1)
                if check == false
                    return false
                end
                if i != 3 && i != 7 && number.numeric? == false
                    check = false
                end
                if (i == 3 || i == 7) && number[i] != '-'
                    check == false
                end
            end
        else
            return false
        end
        new_p = Person.new(name, number, is_listed)
        if @people_listed.hash_key?(name)
            @people_unlisted.push(new_p)
        else
            @people_unlisted = {name => new_p}
        end
        true
    end

    def lookup(name)
        if @people_listed.hash_key?(name)
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
end

class Person
    def initialize(name, number, is_listed)
        @name = name
        @number = number
        @is_listed = is_listed
    end
end
end