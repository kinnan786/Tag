/****** Object:  StoredProcedure [tallal78_8].[spVoteTag]    Script Date: 10/13/2014 10:18:49 PM ******/
DROP PROCEDURE [tallal78_8].[spVoteTag]
GO
/****** Object:  StoredProcedure [tallal78_8].[spVoteTag]    Script Date: 10/13/2014 10:18:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [tallal78_8].[spVoteTag]
    @TagId INT ,
    @Link VARCHAR(MAX) ,
    @VoteType VARCHAR(MAX) ,
    @UserId INT
AS
    BEGIN

        DECLARE @downvote INT = 0
        DECLARE @upvote INT = 0
        DECLARE @PremalinkTagId INT = 0
        DECLARE @PremalinkId INT = 0
        DECLARE @returnvalue INT = 0

        SELECT  @PremalinkId = ISNULL(id, 0)
        FROM    Premalink
        WHERE   Link = @Link

        SELECT  @PremalinkTagId = Id
        FROM    PremalinkTags
        WHERE   Tag_Id = @TagId
                AND Premalink_Id = @PremalinkId

        IF @VoteType = 'UpVote'
            SET @upvote = 1     
        ELSE
            SET @downvote = 1

        IF NOT EXISTS ( SELECT  *
                        FROM    PremalinkTag_User
                        WHERE   UserId = @UserId
                                AND PremalinkTagId = @PremalinkTagId )
            BEGIN

                INSERT  INTO [PremalinkTag_User]
                        ( [UserId] ,
                          [UpVote] ,
                          [DownVote] ,
                          [PremalinkTagId]
                        )
                VALUES  ( @UserId ,
                          @upvote ,
                          @downvote ,
                          @PremalinkTagId
                        )
            END
        ELSE
            BEGIN

                IF @upvote = 1
                    AND ( SELECT    ISNULL(DownVote, 0)
                          FROM      PremalinkTag_User
                          WHERE     UserId = @UserId
                                    AND PremalinkTagId = @PremalinkTagId
                        ) = 1
                    BEGIN
                        UPDATE  [PremalinkTag_User]
                        SET     [UpVote] = ( SELECT ISNULL(UpVote, 0)
                                             FROM   PremalinkTag_User
                                             WHERE  Id = @PremalinkTagId
                                                    AND UserId = @UserId
                                           ) + 1 ,
                                [DownVote] = ( SELECT   ISNULL(DownVote, 0)
                                               FROM     PremalinkTag_User
                                               WHERE    Id = @PremalinkTagId
                                                        AND UserId = @UserId
                                             ) - 1
                        WHERE   Id = @PremalinkTagId
		
                        SELECT  @returnvalue = 1

                    END
                ELSE
                    IF @downvote = 1
                        AND ( SELECT    ISNULL(UpVote, 0)
                              FROM      PremalinkTag_User
                              WHERE     Id = @PremalinkTagId
                                        AND UserId = @UserId
                            ) = 1
                        BEGIN
				 		
                            UPDATE  [PremalinkTag_User]
                            SET     [UpVote] = ( SELECT ISNULL(UpVote, 0) - 1
                                                 FROM   PremalinkTags
                                                 WHERE  UserId = @UserId
                                                        AND Id = @PremalinkTagId
                                               ) ,
                                    [DownVote] = ( SELECT   ISNULL(DownVote, 0)
                                                            + 1
                                                   FROM     PremalinkTags
                                                   WHERE    UserId = @UserId
                                                            AND Id = @PremalinkTagId
                                                 )
                            WHERE   UserId = @UserId
                                    AND Id = @PremalinkTagId
		
                            SELECT  @returnvalue = 2

                        END
			 
                UPDATE  [PremalinkTag_User]
                SET     [UpVote] = ISNULL(@upvote, 0) ,
                        [DownVote] = ISNULL(@downvote, 0)
                WHERE   UserId = @UserId
                        AND PremalinkTagId = @PremalinkTagId
            END
        SELECT  @returnvalue
    END
GO
