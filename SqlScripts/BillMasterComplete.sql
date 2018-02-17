create table DataWareHouse.dbo.BillMaster
(
	BillMasterID int primary key identity(1,1)
	,BillNo varchar(20) not null
	,PatientId int not null
	,BillDate datetime not null
	,BillPrice money not null
	,BillDiscount float not null
	,BillHSTAmount money not null
	,BillTotal money not null
	,BillPaid money not null
	,BillBalance money not null
	,IsOutGoing bit not null
	,BillPaymentType varchar(50)
	,BillOutgoingAmt money
	,BillOutgoingDiscAmt money
	,BillOutgoingPct float
	,BillVoid bit
	,BillCreatedBy varchar(100)
	,BillModifiedBy varchar(100)
	,BillModifiedDate datetime
	,CreateTs datetime
	,UpdateTs datetime
)

-- insert values in BillMaster table

insert into DataWareHouse.dbo.BillMaster
select tpb.BillNo as BillNo
,tpb.PatId as PatientId
,tpb.BillDate as BillDate
,isnull(tpb.Price,0) as BillPrice
,isnull(tpb.BillDiscountAmt,0) as BillDiscount
,isnull(tpb.BillHstAmt,0) as BillHSTAmount
,isnull(tpb.TotalPrice,0) as BillTotal
,isnull(tpb.BillAmtPaid,0) as BillPaid
,isnull(tpb.BillRemainingAmt,0) as BillBalance
,case when isnull(tpb.BillOutGngAmt,0) > 0 then 1 else 0 end as IsOutGoing
,tpb.BillPaymentType as BillPaymentType
,isnull(tpb.BillOutGngAmtPc,0) as BillOutgoingAmt
,isnull(tpb.BillOutGngDiscountAmt,0) as BillOutgoingDiscAmt
,isnull(tpb.BillOutGngAmtPc,0) as BillOutgoingPct
,tpb.BillIsVoid as BillVoid
,tau.usrFullName as BillCreatedBy
,mtau.usrFullName as BillModifiedBy
,tpb.BillLastModifiedDate as BillModifiedDate
,getdate() as CreateTs
,getdate() as UpdateTs
from pat.tbl_PatientBill tpb
join dbo.tbl_appUsers tau on tpb.UserId = tau.usruserid  -- bills creating user
join dbo.tbl_appUsers mtau on tpb.UserId=mtau.usruserid