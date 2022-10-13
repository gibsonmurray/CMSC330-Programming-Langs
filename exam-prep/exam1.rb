class CatRecord

    def initialize(filename)
        @cats = []
        @months = Array.new(12, 0)
        File.readlines(filename).each do |line|
            if line.match(/^([A-Z][a-z]+)\, (\d{2}\/\d{2}\/\d{2})\, (Adopted | Available)$/)
                puts "inside"
                @cats << [$1, $2, $3]   # Name, Date, Availability
                month = $2.match(/\/(\d{2})\//).to_s
                @months[$1.to_i - 1] += 1
            end
        end
    end

    def get_cat_status_by_name(cat_name)
        ans = nil
        for cat in @cats
            if cat_name == cat[0]
                ans = cat[2]
            end
        end
        ans
    end

    def take_in_cat_amount_by_month(month)
        @months[month - 1]
    end

    def max_adopted_cat_month()
        month = nil
        max = 0
        for i in 0...12
            if @months[i] > max
                month = i
            end
        end
        return month
    end

end