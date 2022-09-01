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
    raise Exception, "Not Implemented"
end

def nthmax(n, a)
    raise Exception, "Not Implemented"
end

def freq(s)
    raise Exception, "Not Implemented"
end

def zipHash(arr1, arr2)
    raise Exception, "Not Implemented"
end

def hashToArray(hash)
    raise Exception, "Not Implemented"
end
