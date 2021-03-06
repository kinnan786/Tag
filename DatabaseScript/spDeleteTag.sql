/****** Object:  StoredProcedure [tallal78_8].[spDeleteTag]    Script Date: 10/13/2014 10:18:49 PM ******/
DROP PROCEDURE [tallal78_8].[spDeleteTag]
GO
/****** Object:  StoredProcedure [tallal78_8].[spDeleteTag]    Script Date: 10/13/2014 10:18:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [tallal78_8].[spDeleteTag]
    @PremalinkId BIGINT ,
    @TagId BIGINT
AS
    BEGIN
        DECLARE @Id BIGINT = 0

        SELECT  @Id = id
        FROM    PremalinkTags
        WHERE   Premalink_Id = @PremalinkId
                AND Tag_Id = @TagId

        DELETE  PremalinkTag_User
        WHERE   PremalinkTagId = @Id

        DELETE  PremalinkTags
        WHERE   Premalink_Id = @PremalinkId
                AND Tag_Id = @TagId
        
    END

GO
