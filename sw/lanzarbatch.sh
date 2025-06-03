#!/bin/bash

for file in *.pdf;
 do
    if [ -f "$file" ];
     then
       python3 musica.py --file_name "$file" --custom_id "$(basename "$file" .pdf)"> $(basename "$file" .pdf)_batch_order.txt;
fi;
done
