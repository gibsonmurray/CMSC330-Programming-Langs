class PhoneBook
    def initialize
        @people = Array.new(0){Array.new(0)}
    end

    def add(name, number, is_listed)
        if number.length != 12 || ((number =~ /^\d{3}\-\d{3}\-\d{4}$/) == nil) # if number is invalid
            return false
        end
        for arr in @people
            if arr[0] == name # if person is the same
                return false
            end
            if arr[1] == number && arr[2] == true && is_listed == true # if number is the same as another entry and it was listed
                return false
            end
        end
        @people << [name, number, is_listed] # otherwise add it to the phonebook
        true
    end

    def lookup(name)
        for arr in @people
            if name == arr[0] && arr[2] == true
                return arr[1]
            end
        end
        nil
    end

    def lookupByNum(number)
        for arr in @people
            if number == arr[1] && arr[2] == true
                return arr[0]
            end
        end
        nil
    end

    def namesByAc(areacode)
        ans = []
        for arr in @people
            if areacode == arr[1][0..2]
                ans.push(arr[0])
            end
        end
        ans
    end
end