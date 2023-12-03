BULK INSERT dbo.prices_csv
--FROM 'C:\Users\avrob\Downloads\pp-monthly-update-new-version.csv'
FROM 'C:\Users\avrob\Downloads\pp-2022.csv'
WITH (
    BATCHSIZE = 1000000,
	CODEPAGE = '65001',             -- UTF-8
    FORMAT = 'CSV',
    FIRSTROW = 1,                   -- no headers
	FIELDQUOTE = '"',
    FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a'          -- also try '0x0d0a', '\r', '\n' or '\r\n'
);
