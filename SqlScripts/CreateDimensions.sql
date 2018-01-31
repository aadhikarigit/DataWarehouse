
CREATE TABLE [dbo].[MasterSpecialist](
	[ID] [int] NOT NULL,
	[Name] [varchar](60) NULL,
	[Designation] [varchar](100) NULL,
	[NMCRegID] [varchar](20) NULL,
	[NHPCRegID] [varchar](20) NULL,
	[OtherReg] [varchar](20) NULL,
	[PrimarySpeciality] [varchar](50) NULL,
	[SecondarySpeciality] [varchar](50) NULL,
	[PrimaryHospital] [varchar](50) NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_MasterSpecialist] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


CREATE TABLE [dbo].[TestDiagnosis](
	[ID] [int] IDENTITY(1,1) PRIMARY KEY,
	[OrigDiagID] [int] NULL,
	[DiagName] [varchar](100) NULL,
	[OrigTestID] [int] NULL,
	[TestCode] [varchar](50) NULL,
	[Testname] [varchar](200) NULL,
	[TestType] [varchar](100) NULL,
	[Price] [decimal](17, 2) NULL,
	[TotalPrice] [decimal](17, 2) NULL,
	[Specimen] [varchar](100) NULL,
	[Method] [varchar](50) NULL,
	[Schedule] [varchar](50) NULL,
	[Reporting] [varchar](50) NULL,
	[Units] [varchar](50) NULL,
	[MinRange] [varchar](50) NULL,
	[MaxRange] [varchar](50) NULL,
	[LocalDate] [datetime] NULL
) ON [PRIMARY]
GO





CREATE TABLE LoginInfo
(
	 ID				INT IDENTITY(1,1) PRIMARY KEY
	,LoginType		VARCHAR(20) -- Doctor, Member, Patient
	,LoginID		VARCHAR(50)
	,LoginPw		VARCHAR(50)
	,CreateTs		DATETIME
	,UpdateTS		DATETIME
	,IsActive		BIT
)

CREATE TABLE PatientMaster
(
	 ID				INT IDENTITY(1,1) PRIMARY KEY
	,MainPatID		INT		-- Application Generated ID / LOCAL Id
	,IsMember		BIT
	,MemberCode		VARCHAR(50)
	,FirstName		VARCHAR(50)
	,MidName		VARCHAR(50)
	,LastName		VARCHAR(50)
	,FullName		VARCHAR(100)
	,Dob			DATE
	,Gender			CHAR(1)
	,Address1		VARCHAR(100)
	,Address2		VARCHAR(100)
	,Address3		VARCHAR(100)
	,ContactNo		VARCHAR(20)
	,EmailId		VARCHAR(50)
	,IdentityID		VARCHAR(50)
	,IdentityType	VARCHAR(20)
	,Salutation		VARCHAR(5)
	,ContactNo2		VARCHAR(20)
	,ContactNo3		VARCHAR(20)
	,CrdtPrtyId		INT
	,IsActive		BIT
	,CreateTs		DATETIME
	,UpdateTs		DATETIME
)