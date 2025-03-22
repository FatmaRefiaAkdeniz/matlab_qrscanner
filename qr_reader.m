qrcode1 = imread("25_25_qr10.png");

if size(qrcode1, 3) == 3
    qr = rgb2gray(qrcode1); %resim renkliyse siyah beyaza çevirmek için
else 
    qr = qrcode1; %resim zaten siyah beyazsa aynı kalacak
end

qrcode = imbinarize(qr);

if qrcode(1,1) == 1 % Yani, QR kodunun beyaz zemin üzerine siyah kareler olduğunu kontrol et
    qrcode = imcomplement(qrcode);  % Eğer ters ise, renkleri tersine çevir
end

row_sum = sum(qrcode, 2); % Her bir satırdaki ve sütundaki pikselleri topla (sum = 0'sa siyah ve beyaz pikseller yer değiştirdiğinden o sıra beyaz demek.)
col_sum = sum(qrcode, 1);

% İlk ve son beyaz olmayan pikselin konumunu bul
top_row = find(row_sum, 1, "first");
bottom_row = find(row_sum, 1, "last");
left_col = find(col_sum, 1, "first");
right_col = find(col_sum, 1, "last");

version = input("Enter the version of qr code you want to read:");

cropped_qrcode = qrcode(top_row:bottom_row, left_col:right_col); % Görüntüyü belirlenen sınırlar içinde kırp
if cropped_qrcode(1,1) == 1
    cropped_qrcode = imcomplement(cropped_qrcode);  % Eğer ters ise, renkleri tersine çevir
end

if version == 1
    size_of = 21;
elseif version == 2
    size_of = 25;
else
    error("You cannot use that version for this code. ")
end


    figure;
    imshow(cropped_qrcode);  
    binary_qr = imresize(cropped_qrcode, [size_of size_of]); 
    [rows, cols] = size(binary_qr);

if qrcode(1,1) == 1 % normal qr şeklinde mi kontrol et
    qrcode = imcomplement(qrcode);  % Eğer ters ise, renkleri tersine çevir
end   

masking_mode = binary_qr(9, 3:5)


if masking_mode == [0 1 0]
    unmasked_qr = masking010(binary_qr);
elseif masking_mode == [1 1 0]
    unmasked_qr = masking110(binary_qr);
elseif masking_mode == [0 0 0]
    unmasked_qr = masking000(binary_qr);
elseif masking_mode == [1 0 0]
    unmasked_qr = masking100(binary_qr);
elseif masking_mode == [1 0 1]
    unmasked_qr = masking101(binary_qr);
elseif masking_mode == [0 0 1]
    unmasked_qr = masking001(binary_qr);
elseif masking_mode == [1 1 1]
    unmasked_qr = masking111(binary_qr);
elseif masking_mode == [0 1 1]
    unmasked_qr = masking011(binary_qr);
end


unmasked_qr(1:9, 1:9) = binary_qr(1:9, 1:9);
unmasked_qr(rows-7:rows, 1:9) = binary_qr(rows-7:rows, 1:9);
unmasked_qr(1:9, cols-8:cols) = binary_qr(1:9, cols-8:cols);
if version == 1
    unmasked_qr(8:14,7) = binary_qr(8:14,7);
    unmasked_qr(7, 8:14) = binary_qr(7, 8:14);
elseif version == 2
    unmasked_qr(7, 8:17) = binary_qr(7, 8:17);
    unmasked_qr(8:17, 7) = binary_qr(8:17, 7);
    unmasked_qr(17:21, 17:21) = binary_qr(17:21, 17:21);
end


imshow(unmasked_qr);

type_of_data = [unmasked_qr(rows,cols) , unmasked_qr(rows,cols-1), unmasked_qr(rows-1,cols), unmasked_qr(rows-1,cols-1)];

scanned_data = zeros(1, rows*cols);
index = 1;  

num_pairs = floor(cols/2); %qr codeda kaç çift sütun olduğunu buldurur
up_direction = true;  % İlk okumamız yukarı yönlü olacak

% Şimdi sağdan sola doğru her sütun çiftini okuyalım

for pair = 1:num_pairs
    % Hangi sütunları okuyacağımızı hesaplayalım
    col1 = cols - (pair-1)*2;    % Sağdaki sütun
    col2 = col1 - 1;             % Soldaki sütun

    if up_direction
        for i = rows:-1:1
            % Fixed pattern'i kontrol et
            if (i <= 9 && col1 <= 9) || (i <= 9 && col2 >= cols-8) || (i >= rows-8 && col1 <= 9) ||(version ==1 && i == 7 && col1>= 8 && col2 <= 14)||(version >= 2 && i == 7 && col1 >= 8 && col2 <= 17)
                % Fixed pattern bölgesi; atla
                continue;
            end

            scanned_data(index) = unmasked_qr(i, col1);
            scanned_data(index+1) = unmasked_qr(i, col2);
            index = index + 2;
        end
    else
        for i = 1:rows
            % Fixed pattern'i kontrol et
            if (i <= 9 && col1 <= 9) || (i <= 9 && col2 >= cols-8) ||(i >= rows-8 && col1 <= 9) ||(version ==1 && i == 7 && col1>= 8 && col2 <= 14)||(version >= 2 && i == 7 && col1 >= 8 && col2 <= 17)
                % Fixed pattern bölgesi; atla
                continue;
            end

            scanned_data(index) = unmasked_qr(i, col1);
            scanned_data(index+1) = unmasked_qr(i, col2);
            index = index + 2;
        end
    end
    
    up_direction = ~up_direction; % Switch direction after each pair
end

if version == 2
    delete_alignment = [73:82, 111:120, 137, 139, 141, 143, 145];
    scanned_data(delete_alignment) = [];
end
  
scanned_data = imcomplement(scanned_data); %beyazlar 0, siyahlar 1 olsun diye.

type_of_data = scanned_data(1, 1:4);
if type_of_data == [0 1 0 0]
    fprintf("the data type = byte\n");
else
    error("The data stored must be in byte for this code to work!");
end

if masking_mode == [0 0 1]  %hatalı masking sonucu değiştiirlmesi gerekn pikseller
    scanned_data(1,136) = imcomplement(scanned_data(1,136));
    scanned_data(1,140) = imcomplement(scanned_data(1,140));
    scanned_data(1,146) = imcomplement(scanned_data(1,146));
elseif masking_mode == [1 1 0]
    scanned_data(1,138) = imcomplement(scanned_data(1,138));
    scanned_data(1,144) = imcomplement(scanned_data(1,144));
    scanned_data(1,146) = imcomplement(scanned_data(1,146));
elseif masking_mode == [1 1 1]
    scanned_data(1,144) = imcomplement(scanned_data(1,144));
elseif masking_mode == [0 1 1]
    scanned_data(1,136) = imcomplement(scanned_data(1,136));
    scanned_data(1,142) = imcomplement(scanned_data(1,142));
    scanned_data(1,146) = imcomplement(scanned_data(1,146));
    scanned_data(1,150) = imcomplement(scanned_data(1,150));
elseif masking_mode == [1 0 0]
    scanned_data(1,136) = imcomplement(scanned_data(1,136));
    scanned_data(1,140) = imcomplement(scanned_data(1,140));
    scanned_data(1,146) = imcomplement(scanned_data(1,146));
    scanned_data(1,144) = imcomplement(scanned_data(1,144));
    scanned_data(1,150) = imcomplement(scanned_data(1,150));
end

length_of_data = scanned_data(1, 5:5+7);
length_of_data = num2str(length_of_data);
length_of_data = bin2dec(length_of_data);

harf = zeros(1,length_of_data);
scanning = '';
for i=1:length_of_data
    j = 13+8*i-8;
    bit = scanned_data(1, j:j+7);
    bit_str = num2str(bit);
    bit_dec = bin2dec(bit_str);
    harf = char(bit_dec);
    fprintf("Byte %d: index %d-%d, bit_str = %s, bit_dec = %d, char = %s\n", i, j, j+7, bit_str, bit_dec, harf);
    scanning = [scanning, harf];
end
fprintf("The qr code displays: \n");
disp(scanning);
