use PortfolioProject;

select *
from NashvilleHousing;


--changing sales date

select saledate, convert(date, saledate)
from NashvilleHousing;

update NashvilleHousing
set saledate = convert(date, saledate)

--since the above query didnt work then we'll try this

alter table nashvillehousing
add salesdate date

update nashvilleHousing
set salesdate = convert(date, saledate)

select salesdate
from nashvillehousing;


--populate property address

select propertyaddress
from NashvilleHousing



select a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress, isnull(a.propertyaddress, b.propertyaddress)
from nashvillehousing a
join nashvillehousing b
on a.parcelid = b.parcelid
and a.[uniqueid] <> b.[uniqueid]
where a.propertyaddress is null;

update a
set propertyaddress = isnull(a.propertyaddress, b.propertyaddress)
from nashvillehousing a
join nashvillehousing b
on a.parcelid = b.parcelid
and a.[uniqueid] <> b.[uniqueid]
where a.propertyaddress is null;

select a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress, isnull(a.propertyaddress, b.propertyaddress)
from nashvillehousing a
join nashvillehousing b
on a.parcelid = b.parcelid
and a.[uniqueid] <> b.[uniqueid]


--Breaking out addresss into individual column (Address, City, State)(using substrings)

SELECT PropertyAddress
from NashvilleHousing;

select
SUBSTRING(propertyaddress,1, CHARINDEX(',', propertyaddress)) as Address
from NashvilleHousing;

--(observe that the ',' sign still appears. to remove it we can try this)

select
SUBSTRING(propertyaddress,1, CHARINDEX(',', propertyaddress) -1) as Address
from NashvilleHousing;

select
SUBSTRING(propertyaddress,1, CHARINDEX(',', propertyaddress) -1) as Address,
SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress) +1, len(propertyaddress)) as Address
from NashvilleHousing;

alter table nashvillehousing
add propertysplitAddress nvarchar (255)

update nashvilleHousing
set propertysplitAddress = SUBSTRING(propertyaddress,1, CHARINDEX(',', propertyaddress) -1) 

alter table nashvillehousing
add propertysplitCity nvarchar (255)

update nashvilleHousing
set propertysplitCity = SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress) +1, len(propertyaddress)) 

select *
from NashvilleHousing;

--for OwnerAddress

select OwnerAddress
from NashvilleHousing;

--using parsename

select 
PARSENAME(replace(owneraddress, ',', '.'), 3)
,PARSENAME(replace(owneraddress, ',', '.'), 2)
,PARSENAME(replace(owneraddress, ',', '.'), 1)
from NashvilleHousing

alter table nashvillehousing
add OwnersplitAddress nvarchar (255)

update nashvilleHousing
set OwnersplitAddress = PARSENAME(replace(owneraddress, ',', '.'), 3)

alter table nashvillehousing
add OwnersplitCity nvarchar (255)

update nashvilleHousing
set OwnersplitCity = PARSENAME(replace(owneraddress, ',', '.'), 2)

alter table nashvillehousing
add OwnersplitState nvarchar (255)

update nashvilleHousing
set OwnersplitState = PARSENAME(replace(owneraddress, ',', '.'), 1) 

select *
from NashvilleHousing;



--Change Y and N to Yes and No in SoldasVacant

select distinct (soldasvacant)
from NashvilleHousing;

select distinct (soldasvacant), count(soldasvacant)
from NashvilleHousing
group by soldasvacant
order by 2;

--using case statement

select SoldAsVacant,
case when soldasvacant = 'Y' then 'Yes'
     when soldasvacant = 'N' then 'No'
	 else SoldAsVacant
	 end
from NashvilleHousing

update NashvilleHousing
set soldasvacant = case when soldasvacant = 'Y' then 'Yes'
     when soldasvacant = 'N' then 'No'
	 else SoldAsVacant
	 end

select soldasvacant, count (soldasvacant)
from NashvilleHousing
group by SoldAsVacant
order by 2;

--Removing Duplicates


with rownumCTE as (
select * ,
	row_number () over (
	partition by parcelid,
				 propertyaddress,
				 saleprice,
				 saledate,
				 legalreference
		order by uniqueid)
				 row_num
from NashvilleHousing
)
select *
from rownumCTE
where row_num > 1
order by PropertyAddress

--to delete duplicate rows

with rownumCTE as (
select * ,
	row_number () over (
	partition by parcelid,
				 propertyaddress,
				 saleprice,
				 saledate,
				 legalreference
		order by uniqueid)
				 row_num
from NashvilleHousing
)
Delete
from rownumCTE
where row_num > 1;


--Deleting Column

select *
from NashvilleHousing

alter table NashvilleHousing
drop column PropertyAddress,OwnerAddress,TaxDistrict;

alter table NashvilleHousing
drop column SaleDate;