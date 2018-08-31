
Create PROCEDURE [spGetPremalinkTagsById] @PremaLinkID INT
AS
    BEGIN
        SELECT  t.[Id] AS TagID ,
                t.[Name] AS TagName
        FROM    Tag t
                JOIN PremalinkTags pt ON t.Id = pt.Tag_Id
        WHERE   pt.Premalink_Id = @PremaLinkID
    END
GO


select * from premalink
