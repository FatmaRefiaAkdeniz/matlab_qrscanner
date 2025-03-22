function unmasked_qr = masking100(binary_qr)
[rows, cols] = size(binary_qr);
masked_qr = ones(rows, cols);

for n=1:6:cols
    for m=1:6:rows
        masked_qr(n,:) = 0;
        masked_qr(:,m) = 0;
    end
end

for i =2:6:cols
    for j=2:6:rows
            masked_qr(i, j:j+1) = 0;
            masked_qr(i:i+1, j) = 0;
            masked_qr(i+3:i+4, j+4) = 0;
            masked_qr(i+4, j+3:j+4) = 0;
            masked_qr(i+2:i+3, j+1) = 0;
            masked_qr(i+3, j+1:j+2) = 0;
            masked_qr(i+1, j+2:j+3) = 0;
            masked_qr(i+1:i+2,j+3) = 0;
                     
    end
end
masked_qr = imcrop(masked_qr, [0, 0, rows,cols]);   

masked_qr(1:9, 1:9) = binary_qr(1:9, 1:9);
masked_qr(rows-7:rows, 1:9) = binary_qr(rows-7:rows, 1:9);
masked_qr(1:9, cols-8:cols) = binary_qr(1:9, cols-8:cols);
masked_qr(7,9:13) = binary_qr(7,9:13);
figure;
imshow(masked_qr);

masked_qr = im2bw(masked_qr);

unmasked_qr = xor(binary_qr, masked_qr);
unmasked_qr = imcomplement(unmasked_qr);

end
