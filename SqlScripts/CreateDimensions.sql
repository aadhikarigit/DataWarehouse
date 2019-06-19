
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

CREATE TABLE [dbo].[PatientMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MainPatID] [int] NULL,
	[IsMember] [bit] NULL,
	[MemberCode] [varchar](50) NULL,
	[FirstName] [varchar](50) NULL,
	[MidName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[FullName] [varchar](100) NULL,
	[Dob] [date] NULL,
	[Gender] [char](1) NULL,
	[Address1] [varchar](100) NULL,
	[Address2] [varchar](100) NULL,
	[Address3] [varchar](100) NULL,
	[ContactNo] [varchar](20) NULL,
	[EmailId] [varchar](50) NULL,
	[IdentityID] [varchar](50) NULL,
	[IdentityType] [varchar](20) NULL,
	[Salutation] [varchar](10) NULL,
	[ContactNo2] [varchar](20) NULL,
	[ContactNo3] [varchar](20) NULL,
	[CrdtPrtyId] [int] NULL,
	[IsActive] [bit] NULL,
	[CreateTs] [datetime] NULL,
	[UpdateTs] [datetime] NULL,
	[CreditParty] [varchar](100) NULL,
	[NepaliDate] [nvarchar](15) NULL,
	[Requestor] [nvarchar](255) NULL,
	[Age] [nvarchar](20) NULL,
	[PDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]