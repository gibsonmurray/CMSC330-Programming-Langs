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
            for i in 2..n - 1 do
                ans << (ans[i - 2] + ans[i - 1])
            end
        end
    end
    ans
end

def isPalindrome(n)
    check = []
    str = n.to_s
    for i in 0..str.length/2 do
        check.push(str[i])
    end
    for i in str.length()/2..str.length() do
        if check[-1] == str[i]
            check.pop
        end
    end
    if check.length() != 0
        return false
    else
        return true
    end
end

def nthmax(n, a)
    a = a.sort.reverse
    puts a
    a[n]
end

def freq(s)
    if s.length == 0
        return ""
    end
    dict = Hash.new(0)
    for c in s do
        dict[s[i]]++
    dict.max_by{|k,v| v}
end

def zipHash(arr1, arr2)
    raise Exception, "Not Implemented"
end

def hashToArray(hash)
    raise Exception, "Not Implemented"
end

puts freq("hello").to_s
end