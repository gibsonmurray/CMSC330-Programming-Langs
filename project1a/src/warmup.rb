def fib(n)
    ans = []
    if n == 0
        # do nothing
    elsif n == 1
        ans << 0
    else
        ans << 0
        ans << 1
        if n > 2 
            for i in 2..(n - 1) do
                ans << (ans[i - 2] + ans[i - 1])
            end
        end
    end
    ans
end

def isPalindrome(n) 
    str = n.to_s
    for i in 0..((str.length/2).floor)
        if str[i] != str[-1-i]
            return false
        end
    end
    true
end

def nthmax(n, a)
    a = a.sort.reverse
    a[n]
end

def freq(s)
    if s.length == 0
        return ""
    end
    dict = Hash.new(0)
    for i in 1..s.length do
        dict[s[i]] = dict[s[i]] + 1
    end
    dict.max_by{|k,v| v}[0]
end

def zipHash(arr1, arr2)
    if arr1.length != arr2.length
        return nil
    end
    ans = Hash.new
    for i in 0..(arr1.length - 1)
        ans[arr1[i]] = arr2[i]
    end
    ans
end

def hashToArray(hash)
    ans = []
    hash.each do |key, value|
        ans << [key, value]
    end
    ans
end