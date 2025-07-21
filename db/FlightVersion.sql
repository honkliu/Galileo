/****** Object:  Table [dbo].[FlightVersion]    Script Date: 7/21/2025 9:58:39 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[FlightVersion](
 [FlightVersionKey] [int] IDENTITY(1,1) NOT NULL,
 [FlightKey] [int] NOT NULL,
 [BingFlightID] [nvarchar](50) NULL,
 [ExperimentKey] [int] NOT NULL,
 [LinkedParentFlightKey] [int] NULL,
 [FlightVersionCreatedDts] [datetime] NOT NULL,
 [FlightVersionCreatedBy] [nvarchar](50) NOT NULL,
 [ClonedFlightVersionKey] [int] NULL,
 [PriorFlightVersionKey] [int] NULL,
 [FlightName] [nvarchar](150) NULL,
 [FlightDesc] [nvarchar](1000) NULL,
 [FlightOwners] [nvarchar](500) NULL,
 [FlightTags] [nvarchar](500) NULL,
 [FlightFeatureAreaNames] [nvarchar](500) NULL,
 [KeepSyncedWithFlightKey] [int] NULL,
 [FlightIsActive] [bit] NOT NULL,
 [FlightVersionChangeLogKey] [int] NOT NULL,
 [BucketIDs] [nvarchar](989) NULL,
 [IsRunweightLocked] [bit] NULL,
 [FlightDeployExpireDts] [datetime] NULL,
 [IsShutdown] [bit] NOT NULL,
 [isFlightReadOnly] [bit] NOT NULL,
 [SubFlightIds] [nvarchar](128) NULL,
 [FeatureTypeNames] [nvarchar](128) NULL,
 [IsBCFlight] [bit] NOT NULL,
 CONSTRAINT [PK_FlightVersion] PRIMARY KEY CLUSTERED 
(
 [FlightVersionKey] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[FlightVersion]  WITH NOCHECK ADD  CONSTRAINT [FK_FlightVersion_ChangeLog] FOREIGN KEY([FlightVersionChangeLogKey])
REFERENCES [dbo].[ChangeLog] ([ChangeLogKey])
GO

ALTER TABLE [dbo].[FlightVersion] CHECK CONSTRAINT [FK_FlightVersion_ChangeLog]
GO

ALTER TABLE [dbo].[FlightVersion]  WITH NOCHECK ADD  CONSTRAINT [FK_FlightVersion_Experiment] FOREIGN KEY([ExperimentKey])
REFERENCES [dbo].[Experiment] ([ExperimentKey])
GO

ALTER TABLE [dbo].[FlightVersion] CHECK CONSTRAINT [FK_FlightVersion_Experiment]
GO

ALTER TABLE [dbo].[FlightVersion]  WITH NOCHECK ADD  CONSTRAINT [FK_FlightVersion_Flight] FOREIGN KEY([FlightKey])
REFERENCES [dbo].[Flight] ([FlightKey])
GO

ALTER TABLE [dbo].[FlightVersion] CHECK CONSTRAINT [FK_FlightVersion_Flight]
GO

ALTER TABLE [dbo].[FlightVersion]  WITH NOCHECK ADD  CONSTRAINT [FK_FlightVersion_Flight1] FOREIGN KEY([LinkedParentFlightKey])
REFERENCES [dbo].[Flight] ([FlightKey])
GO

ALTER TABLE [dbo].[FlightVersion] CHECK CONSTRAINT [FK_FlightVersion_Flight1]
GO

ALTER TABLE [dbo].[FlightVersion]  WITH NOCHECK ADD  CONSTRAINT [FK_FlightVersion_Flight2] FOREIGN KEY([KeepSyncedWithFlightKey])
REFERENCES [dbo].[Flight] ([FlightKey])
GO

ALTER TABLE [dbo].[FlightVersion] CHECK CONSTRAINT [FK_FlightVersion_Flight2]
GO

ALTER TABLE [dbo].[FlightVersion]  WITH NOCHECK ADD  CONSTRAINT [FK_FlightVersion_FlightVersion] FOREIGN KEY([ClonedFlightVersionKey])
REFERENCES [dbo].[FlightVersion] ([FlightVersionKey])
GO

ALTER TABLE [dbo].[FlightVersion] CHECK CONSTRAINT [FK_FlightVersion_FlightVersion]
GO

ALTER TABLE [dbo].[FlightVersion]  WITH NOCHECK ADD  CONSTRAINT [FK_FlightVersion_FlightVersion_PriorFlightVersionKey] FOREIGN KEY([PriorFlightVersionKey])
REFERENCES [dbo].[FlightVersion] ([FlightVersionKey])
GO

ALTER TABLE [dbo].[FlightVersion] CHECK CONSTRAINT [FK_FlightVersion_FlightVersion_PriorFlightVersionKey]
GO

ALTER TABLE [dbo].[FlightVersion]  WITH CHECK ADD  CONSTRAINT [Validation of FlightVersion Record Failed in SVF] CHECK  (((1)=(1)))
GO

ALTER TABLE [dbo].[FlightVersion] CHECK CONSTRAINT [Validation of FlightVersion Record Failed in SVF]
GO


 