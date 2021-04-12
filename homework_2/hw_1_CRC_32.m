% decVal = hex2dec('0x104C11DB7')
% binVal = dec2bin(decVal)
% 100000100110000010001110110110111

A = load('inputdata.mat','-mat')
inputdata = A.packet
p = [1 0 0 0 0 0 1 0 0 1 1 0 0 0 0 0 1 0 0 0 1 1 1 0 1 1 0 1 1 0 1 1 1] % CRC-32 polynomial C(x)
% inputdata = [p,p,1] % for testing
check = zeros(1, 33) % for store the answer after XOR
data = [inputdata, zeros(1,32)] % inputdata + 32 of zero in the back
l = length(data)
msb = 1
lsb = 33
check_msb = 34
check_lsb = 33
while lsb <= l
    check = xor(p, [check(check_msb:check_lsb), data(msb:lsb)])
    i = 1
    % find the first 1 in check
    while i <= 33
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

check = [check(1 + l + 1 - msb:check_lsb), data(msb:l)]
CRC_32 = [inputdata, check(2:33)] % inputdata + 32 of check in the back
