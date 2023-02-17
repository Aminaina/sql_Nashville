SELECT *
FROM dbo.[Nashville Housing Data for Data Cleaning]
 

UPDATE dbo.[Nashville Housing Data for Data Cleaning]
set SaleDate = CONVERT(Date,SaleDate )
--change type of column SaleDate to Date
ALTER TABLE dbo.[Nashville Housing Data for Data Cleaning]
Alter column SaleDate Date;
 --fix null of ownerAddress
 SELECT [UniqueID ] , PropertyAddress, OwnerAddress, ISNULL (PropertyAddress, OwnerAddress)
 FROM dbo.[Nashville Housing Data for Data Cleaning]
 UPDATE dbo.[Nashville Housing Data for Data Cleaning]
 set OwnerAddress = ISNULL (PropertyAddress, OwnerAddress)
 --ParcelID 
SELECT DISTINCT ParcelID, COUNT(ParcelID)
FROM dbo.[Nashville Housing Data for Data Cleaning]
 GROUP BY ParcelID
 ORDER BY COUNT(ParcelID) desc
 SELECT * 
FROM dbo.[Nashville Housing Data for Data Cleaning]
WHERE ParcelID = '034 07 0B 015.00'
-- UPDATE PropertyAddress AND OwnerAddress OF [UniqueID ]=  46919
 UPDATE dbo.[Nashville Housing Data for Data Cleaning]
  SET PropertyAddress = '2524  VAL MARIE DR, MADISON'
 WHERE [UniqueID ]=  46919
SELECT * 
FROM dbo.[Nashville Housing Data for Data Cleaning]
WHERE ParcelID = '044 15 0 005.00'
--DELET ROW REPEATE  [UniqueID ]= 33364  = 33363 AND ParcelID = '044 15 0 005.00'
 DELETE FROM  dbo.[Nashville Housing Data for Data Cleaning] WHERE [UniqueID ] = 33363
 
 
  -- PROPETYADDRESS
  SELECT  a.ParcelID, a.PropertyAddress,a.SaleDate, b.ParcelID, b.PropertyAddress, b.SaleDate
  FROM dbo.[Nashville Housing Data for Data Cleaning] a
  JOIN dbo.[Nashville Housing Data for Data Cleaning] B
  ON  a.ParcelID = b.ParcelID
  And a.SaleDate = b.SaleDate
  AND a.[UniqueID ] <> b.[UniqueID ]
  WHERE a.PropertyAddress IS NULL
 UPDATE dbo.[Nashville Housing Data for Data Cleaning]
 SET PropertyAddress = '2117  PAULA DR, MADISON'
 WHERE ParcelID = '034 03 0 059.00'
 AND SaleDate = '2015-08-13'
 UPDATE dbo.[Nashville Housing Data for Data Cleaning]
 SET PropertyAddress = '815  31ST AVE N, NASHVILLE'
 WHERE ParcelID = '092 06 0 282.00'
 AND SaleDate = '2015-02-20'
 -- full Propertyadress where is null depending on ParcelID
   SELECT  a.ParcelID, a.PropertyAddress,  b.ParcelID, b.PropertyAddress,  ISNULL(a.PropertyAddress, b.PropertyAddress)
  FROM dbo.[Nashville Housing Data for Data Cleaning] a
   JOIN  dbo.[Nashville Housing Data for Data Cleaning] B
  ON  a.ParcelID = b.ParcelID
  AND a.[UniqueID ] <> b.[UniqueID ]
   WHERE a.PropertyAddress IS NULL
  ORDER BY a.SaleDate
  UPDATE a
  SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
  FROM dbo.[Nashville Housing Data for Data Cleaning] a
   JOIN  dbo.[Nashville Housing Data for Data Cleaning] B
  ON  a.ParcelID = b.ParcelID
  AND a.[UniqueID ] <> b.[UniqueID ]
   WHERE a.PropertyAddress IS NULL
   --breaking out ADDRESS into individual columns (ADDRES, city, state)

SELECT PropertyAddress , SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1,(LEN(PropertyAddress) )) as city,
LEFT(PropertyAddress,CHARINDEX(',', PropertyAddress) -1) as address, SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1 ) as address
FROM dbo.[Nashville Housing Data for Data Cleaning]
 
 ALTER TABLE dbo.[Nashville Housing Data for Data Cleaning]
 ADD  addresspro NVARCHAR(255);
 UPDATE dbo.[Nashville Housing Data for Data Cleaning]
 SET addresspro = SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1 )
   ALTER TABLE dbo.[Nashville Housing Data for Data Cleaning]
 ADD  citypro NVARCHAR(255);
 UPDATE dbo.[Nashville Housing Data for Data Cleaning]
 SET citypro = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1,(LEN(PropertyAddress) ))

 --Change Y and N to Yes and No in "sold AS vacant"

 SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
 FROM dbo.[Nashville Housing Data for Data Cleaning]
 GROUP BY SoldAsVacant
 ORDER BY 2
 SELECT SoldAsVacant,
 case when SoldAsVacant = 'Y' THEN 'Yes'
 WHEN SoldAsVacant = 'N' THEN 'No'
 Else SoldAsVacant 
 END
 FROM dbo.[Nashville Housing Data for Data Cleaning]
 ORDER BY 1
 UPDATE dbo.[Nashville Housing Data for Data Cleaning]
 SET SoldAsVacant = case when SoldAsVacant = 'Y' THEN 'Yes'
 WHEN SoldAsVacant = 'N' THEN 'No'
 Else SoldAsVacant 
 END
 
 -- Remove Duplicates
 SELECT * 
 FROM dbo.[Nashville Housing Data for Data Cleaning]


 WITH RowNumCTE AS(
 SELECT *,
   ROW_NUMBER() OVER(
   PARTITION BY ParcelID,
		   PropertyAddress,
		   SaleDate,
		   SalePrice,
		   LegalReference
		   Order by
		   UniqueID
          )rownum
 FROM dbo.[Nashville Housing Data for Data Cleaning]
  )
  DELETE
  FROM RowNumCTE
  WHERE rownum >1
  ----------------------------------
  --Delete unused Column 
  SELECT * 
  FROM dbo.[Nashville Housing Data for Data Cleaning]
  ALTER TABLE dbo.[Nashville Housing Data for Data Cleaning]
 DROP COLUMN PropertyAddress, OwnerName, TaxDistrict
