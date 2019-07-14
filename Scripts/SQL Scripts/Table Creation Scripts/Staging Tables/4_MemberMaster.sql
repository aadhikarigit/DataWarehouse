USE [Stag_Carelab_Ban]
GO

/****** Object:  Table [dbo].[MemberMaster]    Script Date: 7/8/2019 3:14:35 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MemberMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
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
	[IsSync] [bit] NULL,
	[CreateTs] [datetime] NULL,
	[UpdateTs] [datetime] NULL,
	[PatId] [int] NULL,
	[fiscalyear] [varchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[MemberMaster] ADD  DEFAULT ((0)) FOR [IsSync]
GO