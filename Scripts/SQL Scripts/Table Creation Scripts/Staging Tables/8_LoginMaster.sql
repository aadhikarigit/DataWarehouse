USE [Stag_Carelab_Ban]
GO

/****** Object:  Table [dbo].[LoginMaster]    Script Date: 7/8/2019 3:13:44 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[LoginMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[LoginType] [varchar](20) NULL,
	[LoginTypeID] [varchar](50) NULL,
	[LoginID] [varchar](50) NULL,
	[LoginPw] [varchar](50) NULL,
	[CreateTs] [datetime] NULL,
	[UpdateTS] [datetime] NULL,
	[IsActive] [bit] NULL,
	[UserRole] [int] NULL,
	[_OrigId] [int] NULL,
	[ClientId] [int] NULL,
	[IsSync] [bit] NULL,
	[UserType] [int] NOT NULL,
	[ReferrerId] [int] NOT NULL,
	[fiscalyear] [varchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[LoginMaster] ADD  DEFAULT ((0)) FOR [IsSync]
GO

ALTER TABLE [dbo].[LoginMaster] ADD  DEFAULT ((1)) FOR [UserType]
GO

ALTER TABLE [dbo].[LoginMaster] ADD  DEFAULT ((0)) FOR [ReferrerId]
GO