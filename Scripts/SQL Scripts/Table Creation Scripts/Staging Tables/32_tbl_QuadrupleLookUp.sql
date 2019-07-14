USE [Stag_Carelab_Ban]
GO

/****** Object:  Table [dbo].[tbl_QuadrupleLookUp]    Script Date: 7/8/2019 3:18:31 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_QuadrupleLookUp](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LocalID] [int] NULL,
	[GroupName] [nvarchar](max) NULL,
	[Remarks_main] [nvarchar](max) NULL,
	[Interpretation] [nvarchar](max) NULL,
	[Disorder] [nvarchar](max) NULL,
	[Screen_+veCutoff] [nvarchar](max) NULL,
	[Remarks] [nvarchar](max) NULL,
	[Method] [nvarchar](max) NULL,
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

ALTER TABLE [dbo].[tbl_QuadrupleLookUp] ADD  DEFAULT (getdate()) FOR [CreateTs]
GO

ALTER TABLE [dbo].[tbl_QuadrupleLookUp] ADD  DEFAULT (getdate()) FOR [UpdateTs]
GO