% 10101010
% 10111

inputdata = [1 0 1 0 1 0 1 0]
p = [1 0 1 1 1] % CRC-32 polynomial C(x)
check = zeros(1, 5) % for store the answer after XOR
data = [inputdata, zeros(1, 4)] % inputdata + 4 of zero in the back
msb = 1
lsb = 5
check_msb = 6
check_lsb = 5
while lsb <= 12
    temp = [check(check_msb:check_lsb), data(msb:lsb)]
    check = xor(p, [check(check_msb:check_lsb), data(msb:lsb)])
    i = 1
    % find the first 1 in check
    check
    while i <= 5
        if check(i) == 1
            break
        else
            i = i + 1
        end
    end
    check_msb = i % next round get check(i:33)
    msb = lsb + 1 
    lsb = lsb + i - 1 % next round get data(lsb+1:lsb+i-1)
    % 33 - i + 1 + lsb + i - 1 - lsb - 1 + 1 = 33
end

check = [check(1+13-msb:check_lsb), data(msb:12)]
CRC_4 = [inputdata, check(2:5)] % inputdata + 32 of check in the back
