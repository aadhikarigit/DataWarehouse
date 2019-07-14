USE [Stag_Carelab_Ban]
GO

/****** Object:  Table [dbo].[MasterSpecialist]    Script Date: 7/8/2019 3:14:05 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MasterSpecialist](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[_SpecialistIdOrig] [int] NOT NULL,
	[Name] [varchar](100) NULL,
	[Designation] [varchar](100) NULL,
	[NMCRegID] [varchar](100) NULL,
	[NHPCRegID] [varchar](100) NULL,
	[OtherReg] [varchar](100) NULL,
	[PrimarySpeciality] [varchar](100) NULL,
	[SecondarySpeciality] [varchar](100) NULL,
	[PrimaryHospital] [varchar](100) NULL,
	[IsActive] [bit] NULL,
	[IsReferrer] [bit] NULL,
	[_OrigTabId] [int] NULL,
	[IsSync] [bit] NULL,
	[DigitalSign] [varbinary](max) NULL,
	[AppUserId] [int] NULL,
	[IsDSAccessible] [bit] NULL,
	[fiscalyear] [varchar](10) NOT NULL,
 CONSTRAINT [PK_MasterSpecialist] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[MasterSpecialist] ADD  DEFAULT ((0)) FOR [IsSync]
GO

ALTER TABLE [dbo].[MasterSpecialist] ADD  DEFAULT ((0)) FOR [AppUserId]
GO

ALTER TABLE [dbo].[MasterSpecialist] ADD  DEFAULT ((0)) FOR [IsDSAccessible]
GO