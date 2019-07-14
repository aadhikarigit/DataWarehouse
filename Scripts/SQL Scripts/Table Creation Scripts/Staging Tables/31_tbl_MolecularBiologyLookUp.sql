USE [Stag_Carelab_Ban]
GO

/****** Object:  Table [dbo].[tbl_MolecularBiologyLookUp]    Script Date: 7/8/2019 3:18:14 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_MolecularBiologyLookUp](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LocalID] [int] NULL,
	[GroupName] [nvarchar](max) NULL,
	[Note] [nvarchar](max) NULL,
	[Technology] [nvarchar](max) NULL,
	[PathogenInfo] [nvarchar](max) NULL,
	[Method] [nvarchar](max) NULL,
	[ReferenceResult] [nvarchar](max) NULL,
	[Comments] [nvarchar](max) NULL,
	[Interpretation] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[SampleType] [nvarchar](max) NULL,
	[IsSync] [bit] NULL,
	[CreateTs] [datetime] NULL,
	[UpdateTs] [datetime] NULL,
	[fiscalyear] [varchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[tbl_MolecularBiologyLookUp] ADD  DEFAULT (getdate()) FOR [CreateTs]
GO

ALTER TABLE [dbo].[tbl_MolecularBiologyLookUp] ADD  DEFAULT (getdate()) FOR [UpdateTs]
GO
