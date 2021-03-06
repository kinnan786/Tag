/****** Object:  StoredProcedure [tallal78_8].[spGetUserGeneralInfo]    Script Date: 10/13/2014 10:18:49 PM ******/
DROP PROCEDURE [tallal78_8].[spGetUserGeneralInfo]
GO
/****** Object:  StoredProcedure [tallal78_8].[spGetUserGeneralInfo]    Script Date: 10/13/2014 10:18:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [tallal78_8].[spGetUserGeneralInfo] @UserID INT
AS
    BEGIN
        SELECT  [Id] AS UserID ,
                [Email] ,
                [Password] ,
                [FaceBookId] ,
                [FirstName] AS FirstName ,
                [LastName] AS Lastname ,
                ISNULL([ProfileImage], '') AS ProfileImage ,
                ISNULL([CoverPhoto], '') AS CoverPhoto
        FROM    [User]
        WHERE   id = @UserID
    END


GO
