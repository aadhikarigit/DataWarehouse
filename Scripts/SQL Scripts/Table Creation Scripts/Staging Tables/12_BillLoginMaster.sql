USE [Stag_Carelab_Ban]
GO

/****** Object:  Table [dbo].[BillLoginMaster]    Script Date: 6/26/2019 12:03:08 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[BillLoginMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[_PatientID] [int] NULL,
	[BillLogin] [varchar](50) NULL,
	[BillPassword] [varchar](200) NULL,
	[ClientID] [varchar](50) NULL,
	[IsActive] [bit] NULL,
	[IsMemberMapped] [bit] NULL,
	[IsDocSharable] [bit] NULL,
	[IsSync] [bit] NULL,
	[CreateTs] [datetime] NULL,
	[UpdateTs] [datetime] NULL,
 CONSTRAINT [pk_BillLoginMaster_Id] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[BillLoginMaster] ADD  DEFAULT ((0)) FOR [IsSync]
GO

ALTER TABLE [dbo].[BillLoginMaster] ADD [fiscalyear] varchar(10) not null
GO


