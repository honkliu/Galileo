/****** Object:  Table [dbo].[Flight]    Script Date: 7/19/2025 7:24:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Flight](
 [FlightKey] [int] IDENTITY(1,1) NOT NULL,
 [LineKey] [smallint] NOT NULL,
 [FlightID] [nvarchar](50) NOT NULL,
 [FlightCreatedDts] [datetime] NOT NULL,
 [FlightCreatedBy] [nvarchar](50) NOT NULL,
 [LatestFlightVersionKey] [int] NULL,
 [FlightUpdatedDts]  AS (case when coalesce([FlightParameterValueUpdatedDts],(1))>=coalesce([FlightRunWeightUpdatedDts],(1)) AND coalesce([FlightParameterValueUpdatedDts],(1))>=coalesce([FlightAttributeUpdatedDts],(1)) AND coalesce([FlightParameterValueUpdatedDts],(1))>=coalesce([FlightCreatedDts],(1)) then [FlightParameterValueUpdatedDts] when coalesce([FlightRunWeightUpdatedDts],(1))>=coalesce([FlightAttributeUpdatedDts],(1)) AND coalesce([FlightRunWeightUpdatedDts],(1))>=coalesce([FlightCreatedDts],(1)) then [FlightRunWeightUpdatedDts] when coalesce([FlightAttributeUpdatedDts],(1))>=coalesce([FlightCreatedDts],(1)) then [FlightAttributeUpdatedDts] else [FlightCreatedDts] end) PERSISTED,
 [FlightRunWeightUpdatedDts] [datetime] NULL,
 [FlightParameterValueUpdatedDts] [datetime] NULL,
 [FlightAttributeUpdatedDts] [datetime] NULL,
 [FlightUpdatedBy]  AS (case when coalesce([FlightParameterValueUpdatedDts],(1))>=coalesce([FlightRunWeightUpdatedDts],(1)) AND coalesce([FlightParameterValueUpdatedDts],(1))>=coalesce([FlightAttributeUpdatedDts],(1)) AND coalesce([FlightParameterValueUpdatedDts],(1))>=coalesce([FlightCreatedDts],(1)) then [FlightParameterValueUpdatedBy] when coalesce([FlightRunWeightUpdatedDts],(1))>=coalesce([FlightAttributeUpdatedDts],(1)) AND coalesce([FlightRunWeightUpdatedDts],(1))>=coalesce([FlightCreatedDts],(1)) then [FlightRunWeightUpdatedBy] when coalesce([FlightAttributeUpdatedDts],(1))>=coalesce([FlightCreatedDts],(1)) then [FlightAttributeUpdatedBy] else [FlightCreatedBy] end) PERSISTED,
 [FlightRunWeightUpdatedBy] [nvarchar](50) NULL,
 [FlightParameterValueUpdatedBy] [nvarchar](50) NULL,
 [FlightAttributeUpdatedBy] [nvarchar](50) NULL,
 [IsFeature] [bit] NOT NULL,
 CONSTRAINT [PK_Flight] PRIMARY KEY CLUSTERED 
(
 [FlightKey] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Flight] ADD  DEFAULT ((0)) FOR [IsFeature]
GO

ALTER TABLE [dbo].[Flight]  WITH NOCHECK ADD  CONSTRAINT [FK_Flight_FlightVersion1] FOREIGN KEY([LatestFlightVersionKey])
REFERENCES [dbo].[FlightVersion] ([FlightVersionKey])
GO

ALTER TABLE [dbo].[Flight] CHECK CONSTRAINT [FK_Flight_FlightVersion1]
GO

EXEC sys.sp_addextendedproperty @name=N'GlobalName', @value=N'Key' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Flight', @level2type=N'COLUMN',@level2name=N'FlightKey'
GO