/****** Object:  StoredProcedure [tallal78_8].[spGetUserTagSubscription]    Script Date: 10/13/2014 10:18:49 PM ******/
DROP PROCEDURE [tallal78_8].[spGetUserTagSubscription]
GO
/****** Object:  StoredProcedure [tallal78_8].[spGetUserTagSubscription]    Script Date: 10/13/2014 10:18:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [tallal78_8].[spGetUserTagSubscription]
    @UserID INT ,
    @TagName VARCHAR(MAX)
AS
    BEGIN


        SELECT  utf.[Id] AS UserTagSubscriptionId ,
                utf.[TagId] ,
                ( SELECT    Name
                  FROM      Tag t
                  WHERE     t.id = utf.TagId
                ) AS TagName
        FROM    [User_Tag_Follow] utf
        WHERE   utf.UserId = @UserID

    END
GO
