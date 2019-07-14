USE [Stag_Carelab_Ban]
GO

/****** Object:  Table [dbo].[PatientMaster]    Script Date: 7/8/2019 3:15:56 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

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
	[RequestorId] [int] NULL,
	[Requestor] [nvarchar](255) NULL,
	[Age] [nvarchar](20) NULL,
	[PDate] [datetime] NULL,
	[ReferredDoctorId] [int] NULL,
	[ClinicalSymptoms] [nvarchar](50) NULL,
	[Routine] [nvarchar](50) NULL,
	[Stat] [nvarchar](50) NULL,
	[TimeOfCollection] [nvarchar](50) NULL,
	[ClinicalCode] [nvarchar](10) NULL,
	[DiscountRemarks] [nvarchar](250) NULL,
	[IsSync] [bit] NULL,
	[fiscalyear] [varchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[PatientMaster] ADD  DEFAULT ((0)) FOR [IsSync]
GO
