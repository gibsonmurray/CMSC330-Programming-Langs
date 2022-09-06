class PhoneBook
    def initialize
        @people = [][] #indices: 0 = name, 1 = number, 2 = listed
    end

    def add(name, number, is_listed)
        if number.length == 12
            check = true
        end
        if (number =~ /^\d{3}-\d{3}-\d{4}$/) == nil
            return false
        end
        @people.push([name, number, is_listed])
        true
    end

    def lookup(name)
        for arr in @people
            if name == arr[0]
                return arr[1]
            end
        end
        nil
    end

    def lookupByNum(number)
        for arr in @people
            if number == arr[1]
                eturn arr[0]
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
    end
end