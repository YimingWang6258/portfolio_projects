--populate PropertyAddress where is null

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) c
from dbo.Nashville_Housing_1000 a
join dbo.Nashville_Housing_1000 b
on a.ParcelID = b.ParcelID
where a.UniqueID <> b.UniqueID
and a.PropertyAddress is null

UPDATE a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from dbo.Nashville_Housing_1000 a
join dbo.Nashville_Housing_1000 b
on a.ParcelID = b.ParcelID
where a.UniqueID <> b.UniqueID
and a.PropertyAddress is null
-----------------------------------------------------------
--seperate address values
select
substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) address,
substring(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress)) address
from dbo.Nashville_Housing_1000

ALTER TABLE dbo.Nashville_Housing_1000
ADD PropertySplitAddress nvarchar(255)

UPDATE dbo.Nashville_Housing_1000
SET PropertySplitAddress = substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE dbo.Nashville_Housing_1000
ADD PropertySplitCity nvarchar(255)

UPDATE dbo.Nashville_Housing_1000
SET PropertySplitCity = substring(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress))

select parsename(replace(owneraddress, ',', '.'), 3), --parsename only works for '.' not ','
parsename(replace(owneraddress, ',', '.'), 2),
parsename(replace(owneraddress, ',', '.'), 1)
from dbo.Nashville_Housing_1000

ALTER TABLE dbo.Nashville_Housing_1000
ADD OwnerSplitAddress nvarchar(255)

UPDATE dbo.Nashville_Housing_1000
SET OwnerSplitAddress = parsename(replace(owneraddress, ',', '.'), 3)

ALTER TABLE dbo.Nashville_Housing_1000
ADD OwnerSplitCity nvarchar(255)

UPDATE dbo.Nashville_Housing_1000
SET OwnerSplitCity = parsename(replace(owneraddress, ',', '.'), 2)

ALTER TABLE dbo.Nashville_Housing_1000
ADD OwnerSplitState nvarchar(255)

UPDATE dbo.Nashville_Housing_1000
SET OwnerSplitState = parsename(replace(owneraddress, ',', '.'), 1)

select * from dbo.Nashville_Housing_1000
----------------------------------------------------------
--change 'Y', 'N' to 'Yes', 'No' (SoldAsVacant)

select distinct(SoldAsVacant), count(SoldAsVacant)
from dbo.Nashville_Housing_1000
group by SoldAsVacant

select SoldAsVacant,
CASE when SoldAsVacant = 'N' then 'NO' ELSE SoldAsVacant END
from dbo.Nashville_Housing_1000

update dbo.Nashville_Housing_1000
set SoldAsVacant = CASE when SoldAsVacant = 'N' then 'NO' ELSE SoldAsVacant END
-----------------------------------------------------------------------------------
--remove duplicates (in this case, no duplicates)
with cte as(
            select *, 
            row_number()over(partition by ParcelID, PropertyAddress, SaleDate, Saleprice, Legalreference 
                             order by ParcelID) row_num
            from dbo.Nashville_Housing_1000)
select * from cte where row_num > 1
--delete from cte where row_num > 1

--------------------------------------------------------------------------------------
--delete unused columns (just for practice)

alter table dbo.Nashville_Housing_1000
drop column OwnerAddress, PropertyAddress

select * from dbo.Nashville_Housing_1000