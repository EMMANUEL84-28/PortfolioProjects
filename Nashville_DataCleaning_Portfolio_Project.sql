

-- Cleaning  data in SQL Queries

SELECT *
FROM Nashville_Housing;


--Standardize Date Format.


SELECT SaleDate, CONVERT(Date, SaleDate) 
FROM Nashville_Housing;

UPDATE Nashville_Housing
SET SaleDate = CONVERT(Date, SaleDate);

ALTER TABLE Nashville_Housing
ADD SaleDateConverted Date;

UPDATE Nashville_Housing
SET SaleDateConverted = CONVERT(Date, SaleDate);



--Populate Property Addrees data

SELECT *
FROM Nashville_Housing
ORDER BY ParcelID;


SELECT A.ParcelID,
       A.PropertyAddress,
       B.ParcelID,
       B.PropertyAddress,
	   ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM Nashville_Housing AS A
	JOIN Nashville_Housing AS B ON A.ParcelID = B.ParcelID
		AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL;

UPDATE A
       SET PropertyAddress = ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM Nashville_Housing AS A
	JOIN Nashville_Housing AS B ON A.ParcelID = B.ParcelID
		AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL;



--Breaking out Address into individual Columns (Address, city, State).


SELECT PropertyAddress
FROM Nashville_Housing

SELECT 
      SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
      SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1,  LEN(PropertyAddress)) AS Address
FROM Nashville_Housing;

ALTER TABLE Nashville_Housing
ADD PropertySplitAddress nvarchar(200);

UPDATE Nashville_Housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1);

ALTER TABLE Nashville_Housing
ADD PropertySplitCity nvarchar(200);

UPDATE Nashville_Housing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1,  LEN(PropertyAddress));



SELECT OwnerAddress
FROM Nashville_Housing;

SELECT PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
       PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
       PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM Nashville_Housing;


ALTER TABLE Nashville_Housing
ADD OwnerSplitAddress nvarchar(200);

UPDATE Nashville_Housing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3);

ALTER TABLE Nashville_Housing
ADD OwnerSplitCity nvarchar(200);

UPDATE Nashville_Housing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2);

ALTER TABLE Nashville_Housing
ADD OwnerSplitState nvarchar(200);

UPDATE Nashville_Housing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);

SELECT *
FROM Nashville_Housing



-- Change Y and N to Yes and No in 'Sold as Vacant' field.


SELECT DISTINCT SoldASVacant,
                COUNT(SoldASVacant)
FROM Nashville_Housing
GROUP BY SoldASVacant
ORDER BY COUNT(SoldASVacant)

SELECT SoldASVacant,
       CASE WHEN SoldASVacant = 'Y' THEN 'Yes'
	    WHEN SoldASVacant = 'N' THEN 'NO'
	    ELSE SoldASVacant
       END
FROM Nashville_Housing;	



-- Remove Duplicates

WITH RowNumCTE AS (
SELECT *,
       ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference ORDER BY UniqueID) row_num
FROM Nashville_Housing
)
DELETE
FROM RowNumCTE
WHERE row_num > 1;



--Delete Unused Columns


SELECT *
FROM Nashville_Housing

ALTER TABLE Nashville_Housing
DROP COLUMN TaxDistrict;














