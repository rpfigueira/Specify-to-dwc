/*

Queries para mapear a bd a Darwin core - ZOOLOGIA


Taxon

taxonID | scientificNameID | acceptedNameUsageID | parentNameUsageID | originalNameUsageID | nameAccordingToID | namePublishedInID | taxonConceptID | scientificName | acceptedNameUsage | parentNameUsage | originalNameUsage | nameAccordingTo | namePublishedIn | higherClassification | kingdom | phylum | class | order | family | genus | subgenus | specificEpithet | infraspecificEpithet | taxonRank | verbatimTaxonRank | scientificNameAuthorship | vernacularName | nomenclaturalCode | taxonomicStatus | nomenclaturalStatus | taxonRemarks


    * TaxonID
    * ScientificName
    * Binomial
    * HigherTaxonID
    * HigherTaxon
    * Kingdom
    * Phylum
    * Class
    * Order
    * Family
    * Genus
    * Subgenus
    * SpecificEpithet
    * TaxonRank
    * InfraspecificEpithet
    * ScientificNameAuthorship
    * NomenclaturalCode
    * TaxonAccordingTo
    * NamePublishedIn
    * TaxonomicStatus
    * NomenclaturalStatus
    * AcceptedTaxonID
    * AcceptedTaxon
    * BasionymID
    * Basionym

*/

DROP TABLE IF EXISTS dwc.ZOOtaxonDC;


-- para obter taxa no rank em especie

CREATE TABLE dwc.ZOOtaxonDC
SELECT t0.taxonid AS TaxonID,
    t0.fullname AS ScientificName,
    concat(t2.name, ' ', t1.name) AS binomial,
    t7.name AS Kingdom,
    t6.name AS phylum,
    t5.name AS class,
    t4.name AS `order`,
    t3.name AS family,
    t2.name AS genus,
    t1.name AS specificEpithet,
    ti.name AS TaxonRank,
    t0.name AS InfraspecificEpithet,
    t0.Author AS ScientificNameAuthorship,
    t0.text1 AS TaxonomicStatus,
    t0.acceptedid AS AcceptedTaxonID
FROM Zoologia.taxon t0
inner join Zoologia.taxon t1 on t0.parentid = t1.taxonid
inner join Zoologia.taxon t2 on t1.parentid = t2.taxonid
inner join Zoologia.taxon t3 on t2.parentid = t3.taxonid
inner join Zoologia.taxon t4 on t3.parentid = t4.taxonid
inner join Zoologia.taxon t5 on t4.parentid = t5.taxonid
inner join Zoologia.taxon t6 on t5.parentid = t6.taxonid
inner join Zoologia.taxon t7 on t6.parentid = t7.taxonid
inner join Zoologia.taxontreedef td on t0.taxontreedefid = td.taxontreedefid
inner join Zoologia.taxontreedefitem ti on t0.taxontreedefitemid = ti.taxontreedefitemid
where t0.rankid = 230 and t1.rankid = 220;


-- para obter taxa no rank em especie, subespecie

INSERT INTO dwc.ZOOtaxonDC (TaxonID, ScientificName, binomial, Kingdom,
phylum, class, `order`, family, genus, specificEpithet, TaxonRank,
InfraspecificEpithet, ScientificNameAuthorship, TaxonomicStatus, AcceptedTaxonID)
SELECT t0.taxonid AS TaxonID,
    t0.fullname AS ScientificName,
    concat(t1.name, ' ', t0.name) AS binomial,
    t6.name AS Kingdom,
    t5.name AS phylum,
    t4.name AS class,
    t3.name AS `order`,
    t2.name AS family,
    t1.name AS genus,
    t0.name AS specificEpithet,
    ti.name AS TaxonRank,
    null AS InfraspecificEpithet,
    t0.Author AS ScientificNameAuthorship,
    t0.text1 AS TaxonomicStatus,
    t0.acceptedid AS AcceptedTaxonID
FROM Zoologia.taxon t0
inner join Zoologia.taxon t1 on t0.parentid = t1.taxonid
inner join Zoologia.taxon t2 on t1.parentid = t2.taxonid
inner join Zoologia.taxon t3 on t2.parentid = t3.taxonid
inner join Zoologia.taxon t4 on t3.parentid = t4.taxonid
inner join Zoologia.taxon t5 on t4.parentid = t5.taxonid
inner join Zoologia.taxon t6 on t5.parentid = t6.taxonid
inner join Zoologia.taxontreedef td on t0.taxontreedefid = td.taxontreedefid
inner join Zoologia.taxontreedefitem ti on t0.taxontreedefitemid = ti.taxontreedefitemid
where t0.rankid = 220;

ALTER TABLE `dwc`.`ZOOtaxonDC` ADD PRIMARY KEY (`TaxonID`)
, ENGINE = InnoDB;

ALTER TABLE `dwc`.`ZOOtaxonDC` ADD COLUMN `AcceptedTaxon` VARCHAR(255)  AFTER `AcceptedTaxonID`;

UPDATE `dwc`.`ZOOtaxonDC` tdc,  Zoologia.taxon t SET tdc.AcceptedTaxon = t.fullname WHERE tdc.acceptedtaxonid = t.taxonid;


/*
dcterms:Location
locationID | higherGeographyID | higherGeography | continent | waterBody | islandGroup | island | country | countryCode | stateProvince | county | municipality | locality | verbatimLocality | verbatimElevation | minimumElevationInMeters | maximumElevationInMeters | verbatimDepth | minimumDepthInMeters | maximumDepthInMeters | minimumDistanceAboveSurfaceInMeters | maximumDistanceAboveSurfaceInMeters | locationAccordingTo | locationRemarks | verbatimCoordinates | verbatimLatitude | verbatimLongitude | verbatimCoordinateSystem | verbatimSRS | decimalLatitude | decimalLongitude | geodeticDatum | coordinateUncertaintyInMeters | coordinatePrecision | pointRadiusSpatialFit | footprintWKT | footprintSRS | footprintSpatialFit | georeferencedBy | georeferenceProtocol | georeferenceSources | georeferenceVerificationStatus | georeferenceRemarks

    * SamplingLocationID
    * HigherGeographyID
    * HigherGeography
    * Continent
    * Waterbody
    * IslandGroup
    * Island
    * Country
    * CountryCode
    * StateProvince
    * County
    * Locality
    * VerbatimLocality
    * VerbatimElevation
    * MinimumElevationInMeters
    * MaximumElevationInMeters
    * VerbatimDepth
    * MinimumDepthInMeters
    * MaximumDepthInMeters
    * DistanceAboveSurfaceInMetersMinimum
    * DistanceAboveSurfaceInMetersMaximum
    * DecimalLatitude
    * DecimalLongitude
    * GeodeticDatum
    * CoordinateUncertaintyInMeters
    * CoordinatePrecision
    * PointRadiusSpatialFit
    * VerbatimCoordinates
    * VerbatimLatitude
    * VerbatimLongitude
    * GeoreferencedBy
    * GeoreferenceProtocol
    * VerbatimCoordinateSystem
    * GeoreferenceSources
    * GeoreferenceVerificationStatus
    * GeoreferenceRemarks
    * FootprintWKT
    * FootprintSpatialFit
    * SamplingLocationRemarks


Esta tabela tem de ser obtida a partir da relação entre duas tabelas temporárias, para estabelecer a relação entre localidade e geografia
*/

-- query 1

DROP TABLE IF EXISTS dwc.ZOOtempGeography;

-- Criar tabela com registos que incluem árvore completa até county

CREATE TABLE dwc.ZOOtempGeography
SELECT
IFNULL(n9.geographyid,IFNULL(n8.geographyid,IFNULL(n7.geographyid,n6.geographyid))) AS geographyID,
    n6.name AS Continent,
    n7.name AS Country,
    n7.geographyCode AS CountryCode,
    n8.name AS StateProvince,
    n9.name AS County
FROM  Zoologia.geography n6
    JOIN Zoologia.geographytreedefitem ti ON n6.geographytreedefitemid = ti.geographytreedefitemid
    LEFT OUTER JOIN Zoologia.geography n7 ON n7.parentid = n6.geographyid
    LEFT OUTER JOIN Zoologia.geography n8 ON n8.parentid = n7.geographyid
    LEFT OUTER JOIN Zoologia.geography n9 ON n9.parentid = n8.geographyid
WHERE n6.rankid = 100;

-- adicionar registos que incluem árvore completa até StateProvince

INSERT INTO dwc.ZOOtempGeography (geographyID, Continent, Country, CountryCode, StateProvince)
SELECT
IFNULL(n8.geographyid,IFNULL(n7.geographyid,n6.geographyid)) AS geographyID,
    n6.name AS Continent,
    n7.name AS Country,
    n7.geographyCode AS CountryCode,
    n8.name AS StateProvince
FROM  Zoologia.geography n6
    JOIN Zoologia.geographytreedefitem ti ON n6.geographytreedefitemid = ti.geographytreedefitemid
    LEFT OUTER JOIN Zoologia.geography n7 ON n7.parentid = n6.geographyid
    LEFT OUTER JOIN Zoologia.geography n8 ON n8.parentid = n7.geographyid
WHERE n6.rankid = 100;

-- adicionar registos que incluem árvore completa até Country

INSERT INTO dwc.ZOOtempGeography (geographyID, Continent, Country, CountryCode)
SELECT
IFNULL(n7.geographyid,n6.geographyid) AS geographyID,
    n6.name AS Continent,
    n7.name AS Country,
    n7.geographyCode AS CountryCode
FROM Zoologia.geography n6
    JOIN Zoologia.geographytreedefitem ti ON n6.geographytreedefitemid = ti.geographytreedefitemid
    LEFT OUTER JOIN Zoologia.geography n7 ON n7.parentid = n6.geographyid
WHERE n6.rankid = 100;


DROP TABLE IF EXISTS dwc.ZOOtempGeography1;

CREATE TABLE dwc.ZOOtempGeography1 SELECT DISTINCT * FROM dwc.ZOOtempGeography;

DROP TABLE IF EXISTS dwc.ZOOtempGeography;

ALTER TABLE `dwc`.`ZOOtempGeography1` RENAME TO `dwc`.`ZOOtempGeography`;

ALTER TABLE `dwc`.`ZOOtempGeography` ADD PRIMARY KEY (`geographyID`)
, ENGINE = InnoDB;


-- query 2

DROP TABLE IF EXISTS dwc.ZOOtempLocality;

CREATE TABLE dwc.ZOOtempLocality
SELECT
    l.localityid AS SamplingLocationID,
    l.localityName AS locality,
    ce.verbatimLocality AS VerbatimLocality,
    l.verbatimElevation AS VerbatimElevation,
    l.minElevation AS MinimumElevationInMeters,
    l.maxElevation AS MaximumElevationInMeters,
    l.latitude1 AS DecimalLatitude,
    l.longitude1 AS DecimalLongitude,
    l.datum AS GeodeticDatum,
    l.latlongAccuracy AS CoordinatePrecision,
    ce.remarks AS SamplingLocationRemarks,
    l.geographyID,
    ce.collectingeventid
FROM Zoologia.collectionobject co
    INNER JOIN Zoologia.collectingevent ce ON co.collectingeventid = ce.collectingeventid
    LEFT JOIN Zoologia.locality l ON ce.localityid = l.localityid;

ALTER TABLE `dwc`.`ZOOtempLocality` ADD PRIMARY KEY (`collectingeventid`),
 ADD INDEX `new_index`(`geographyID`)
, ENGINE = InnoDB;


/*
SELECT
    l.localityid AS SamplingLocationID,
    n6.name AS Continent,
    n7.name AS Country,
    n8.name AS StateProvince,
    n9.name AS County,
    l.localityName AS locality,
    ce.verbatimLocality AS VerbatimLocality,
    l.verbatimElevation AS VerbatimElevation,
    l.minElevation AS MinimumElevationInMeters,
    l.maxElevation AS MaximumElevationInMeters,
    l.latitude1 AS DecimalLatitude,
    l.longitude1 AS DecimalLongitude,
    l.datum AS GeodeticDatum,
    l.latlongAccuracy AS CoordinatePrecision,
    ce.remarks AS SamplingLocationRemarks
FROM Zoologia.collectionobject co
    INNER JOIN Zoologia.collectingevent ce ON co.collectingeventid = ce.collectingeventid
    LEFT JOIN Zoologia.locality l ON ce.localityid = l.localityid
    LEFT JOIN Zoologia.geography n6 on l.geographyid = n6.geographyid
    RIGHT OUTER JOIN Zoologia.geographytreedefitem ti ON n6.geographytreedefitemid = ti.geographytreedefitemid
    LEFT OUTER JOIN Zoologia.geography n7 ON n7.parentid = n6.geographyid
    LEFT OUTER JOIN Zoologia.geography n8 ON n8.parentid = n7.geographyid
    LEFT OUTER JOIN Zoologia.geography n9 ON n9.parentid = n8.geographyid
WHERE n6.rankid = 100
    AND (n9.geographytreedefitemid IS NOT NULL OR n8.geographytreedefitemid IS NOT NULL)*/

-- query 3 join tables


DROP TABLE IF EXISTS dwc.ZOOlocationDC;

CREATE TABLE dwc.ZOOlocationDC
SELECT
    g.Continent,
    g.Country,
    g.CountryCode,
    g.StateProvince,
    g.County,
    l.SamplingLocationID,
    l.locality,
    l.VerbatimLocality,
    l.VerbatimElevation,
    l.MinimumElevationInMeters,
    l.MaximumElevationInMeters,
    l.DecimalLatitude,
    l.DecimalLongitude,
    l.GeodeticDatum,
    l.CoordinatePrecision,
    l.SamplingLocationRemarks,
    l.collectingeventid
FROM dwc.ZOOtempLocality l
LEFT OUTER JOIN dwc.ZOOtempGeography g ON l.geographyid = g.geographyid;

ALTER TABLE `dwc`.`ZOOlocationDC` ADD PRIMARY KEY (`collectingeventid`)
, ENGINE = InnoDB;

/*
Event
eventID | samplingProtocol | samplingEffort | eventDate | eventTime | startDayOfYear | endDayOfYear | year | month | day | verbatimEventDate | habitat | fieldNumber | fieldNotes | eventRemarks

Sampling event

    * SamplingEventID
    * SamplingProtocol
    * VerbatimCollectingDate
    * EarliestDateCollected
    * LatestDateCollected
    * StartDayOfYear
    * EndDayOfYear
    * StartTimeOfDay
    * EndTimeOfDay
    * YearSampled
    * MonthOfYear
    * DayOfMonth
    * Habitat
    * Behavior
    * Collector
    * CollectorNumber
    * FieldNumber
    * FieldNotes
    * SamplingEventAttributes
    * SamplingEventRemarks


*/

DROP TABLE IF EXISTS dwc.ZOOtempColectores;

CREATE  TABLE dwc.ZOOtempColectores SELECT cl.collectingeventid,
    GROUP_CONCAT(DISTINCT (CONCAT(a.lastname,', ',a.abbreviation)) ORDER BY cl.ordernumber DESC SEPARATOR ', ') AS recordedBy
FROM Zoologia.collector cl
    INNER JOIN Zoologia.agent a
        ON cl.agentid = a.agentid
GROUP BY cl.collectingeventid;

ALTER TABLE `dwc`.`ZOOtempColectores` ADD PRIMARY KEY (`collectingeventid`)
, ENGINE = InnoDB;

DROP TABLE IF EXISTS dwc.ZOOsamplingeventDC;

CREATE TABLE dwc.ZOOsamplingeventDC
SELECT
    ce.collectingeventID AS SamplingEventID,
    ce.startdateverbatim AS VerbatimCollectingDate,
    CASE ce.startDatePrecision
        WHEN 1 THEN
              ( ce.startDate)
        WHEN 2 THEN
              ( LEFT(ce.startDate, 7) )
        WHEN 3 THEN
              ( year(ce.startDate) )
    END AS EarliestDateCollected,
    YEAR(ce.startDate) AS YearSampled,
    IF((ce.startDatePrecision < 3), MONTH(ce.startDate), NULL) AS MonthOfYear,
    IF((ce.startDatePrecision < 2), DAY(ce.startDate), NULL) AS DayOfMonth,    
    tc.recordedBy AS Collector,
    ce.stationFieldNumber AS CollectorNumber,
    ce.remarks AS SamplingEventRemarks
FROM Zoologia.collectingevent ce LEFT JOIN dwc.ZOOtempColectores tc ON ce.collectingeventID = tc.collectingeventID;

ALTER TABLE `dwc`.`ZOOsamplingeventDC` ADD PRIMARY KEY (`SamplingEventID`)
, ENGINE = InnoDB;

/*

Occurrence
occurrenceID | catalogNumber | occurrenceDetails | occurrenceRemarks | recordNumber | recordedBy | individualID | individualCount | sex | lifeStage | reproductiveCondition | behavior | establishmentMeans | occurrenceStatus | preparations | disposition | otherCatalogNumbers | previousIdentifications | associatedMedia | associatedReferences | associatedOccurrences | associatedSequences | associatedTaxa

Sample

    * InstitutionCode
    * CollectionCode
    * CollectionID
    * BasisOfRecord
    * AccessConstraints
    * InformationWithheld
    * Generalizations
    * SampleDetails
    * SampleRemarks
    * CatalogNumber
    * CatalogNumberNumeric
    * IndividualID
    * IndividualCount
    * Citation
    * Sex
    * LifeStage
    * ReproductiveCondition
    * EstablishmentMeans
    * SampleAttributes
    * Preparations
    * Disposition
    * OtherCatalogNumbers
    * AssociatedMedia
    * AssociatedReferences
    * AssociatedSamples
    * AssociatedSequences
    * AssociatedTaxa



-- é necessário inserir os url neste campo do Specify

*/

DROP TABLE IF EXISTS dwc.ZOOtempPreparation;

CREATE TABLE dwc.ZOOtempPreparation
SELECT
    p.collectionobjectid,
    GROUP_CONCAT(DISTINCT ' ', pt.name) AS preparations
FROM Zoologia.preparation p
    JOIN Zoologia.preptype pt ON p.preptypeid = pt.preptypeid
GROUP BY p.collectionobjectid;

ALTER TABLE `dwc`.`ZOOtempPreparation` ADD PRIMARY KEY (`collectionobjectid`)
, ENGINE = InnoDB;

DROP TABLE IF EXISTS dwc.ZOOsamplesDC;

-- Atenção que a ordem das colunas de coa para sex e LifeStage troca entre Mammalia e Aves

CREATE TABLE dwc.ZOOsamplesDC
SELECT
    co.TimestampCreated,
    co.TimestampModified,
    'IICT' AS InstitutionCode,
    'CZ' AS CollectionCode,
    CONCAT('urn:lsid:iict.pt:CZ:', co.catalognumber) AS collectionID,
    'PreservedSpecimen' as BasisOfRecord,
    co.catalogNumber AS catalogNumber,
    co.remarks AS sampleRemarks,
    IFNULL(coa.text1, '') AS sex,
    IFNULL(coa.text4, '') AS LifeStage,
    tp.preparations AS preparations,
    co.altCatalogNumber AS OtherCatalogNumbers,
    coa.text7 AS associatedMedia,
    ce.collectingeventid AS samplescollectingeventid,
    co.collectionobjectid AS samplescollectionobjectid,
    co.collectionid AS internalCollectionID            
FROM Zoologia.collectionobject co
    INNER JOIN Zoologia.collectingevent ce
        ON co.collectingeventid = ce.collectingeventid
    LEFT JOIN Zoologia.collectionobjectattribute coa
        ON co.collectionobjectattributeid = coa.collectionobjectattributeid
    LEFT JOIN dwc.ZOOtempPreparation tp
        ON co.collectionobjectid = tp.collectionobjectid
WHERE co.restrictions = 'publico' AND collectionID = 4
GROUP BY ce.collectingeventid;

/*Adicionar registos de Mammalia*/
INSERT INTO dwc.ZOOsamplesDC
(
    TimestampCreated,
    TimestampModified,
    InstitutionCode,
    CollectionCode,
    collectionID,
    BasisOfRecord,
    catalogNumber,
    sampleRemarks,
    sex,
    LifeStage,
    preparations,
    OtherCatalogNumbers,
    associatedMedia,
    samplescollectingeventid,
    samplescollectionobjectid,
    internalCollectionID
)
SELECT
    co.TimestampCreated,
    co.TimestampModified,
    'IICT' AS InstitutionCode,
    'CZ' AS CollectionCode,
    CONCAT('urn:lsid:iict.pt:CZ:', co.catalognumber) AS collectionID,
    'PreservedSpecimen' as BasisOfRecord,
    co.catalogNumber AS catalogNumber,
    co.remarks AS sampleRemarks,
    IFNULL(coa.text2, '') AS sex,
    IFNULL(coa.text1, '') AS LifeStage,
    tp.preparations AS preparations,
    co.altCatalogNumber AS OtherCatalogNumbers,
    coa.text7 AS associatedMedia,
    ce.collectingeventid AS samplescollectingeventid,
    co.collectionobjectid AS samplescollectionobjectid,
    co.collectionid AS internalCollectionID                 
FROM Zoologia.collectionobject co
    INNER JOIN Zoologia.collectingevent ce
        ON co.collectingeventid = ce.collectingeventid
    LEFT JOIN Zoologia.collectionobjectattribute coa
        ON co.collectionobjectattributeid = coa.collectionobjectattributeid
    LEFT JOIN dwc.ZOOtempPreparation tp
        ON co.collectionobjectid = tp.collectionobjectid
WHERE co.restrictions = 'publico' AND co.collectionID = 32769
GROUP BY ce.collectingeventid;

/*Adicionar registos de Amphibia*/
INSERT INTO dwc.ZOOsamplesDC
(
    TimestampCreated,
    TimestampModified,
    InstitutionCode,
    CollectionCode,
    collectionID,
    BasisOfRecord,
    catalogNumber,
    sampleRemarks,
    sex,
    LifeStage,
    preparations,
    OtherCatalogNumbers,
    associatedMedia,
    samplescollectingeventid,
    samplescollectionobjectid,
    internalCollectionID
)
SELECT
    co.TimestampCreated,
    co.TimestampModified,
    'IICT' AS InstitutionCode,
    'CZ' AS CollectionCode,
    CONCAT('urn:lsid:iict.pt:CZ:', co.catalognumber) AS collectionID,
    'PreservedSpecimen' as BasisOfRecord,
    co.catalogNumber AS catalogNumber,
    co.remarks AS sampleRemarks,
    IFNULL(coa.text2, '') AS sex,
    IFNULL(coa.text1, '') AS LifeStage,
    tp.preparations AS preparations,
    co.altCatalogNumber AS OtherCatalogNumbers,
    coa.text7 AS associatedMedia,
    ce.collectingeventid AS samplescollectingeventid,
    co.collectionobjectid AS samplescollectionobjectid,
    co.collectionid AS internalCollectionID                 
FROM Zoologia.collectionobject co
    INNER JOIN Zoologia.collectingevent ce
        ON co.collectingeventid = ce.collectingeventid
    LEFT JOIN Zoologia.collectionobjectattribute coa
        ON co.collectionobjectattributeid = coa.collectionobjectattributeid
    LEFT JOIN dwc.ZOOtempPreparation tp
        ON co.collectionobjectid = tp.collectionobjectid
WHERE co.restrictions = 'publico' AND co.collectionID = 98304
GROUP BY ce.collectingeventid;

/*Adicionar registos de Reptilia*/
INSERT INTO dwc.ZOOsamplesDC
(
    TimestampCreated,
    TimestampModified,
    InstitutionCode,
    CollectionCode,
    collectionID,
    BasisOfRecord,
    catalogNumber,
    sampleRemarks,
    sex,
    LifeStage,
    preparations,
    OtherCatalogNumbers,
    associatedMedia,
    samplescollectingeventid,
    samplescollectionobjectid,
    internalCollectionID
)
SELECT
    co.TimestampCreated,
    co.TimestampModified,
    'IICT' AS InstitutionCode,
    'CZ' AS CollectionCode,
    CONCAT('urn:lsid:iict.pt:CZ:', co.catalognumber) AS collectionID,
    'PreservedSpecimen' as BasisOfRecord,
    co.catalogNumber AS catalogNumber,
    co.remarks AS sampleRemarks,
    IFNULL(coa.text2, '') AS sex,
    IFNULL(coa.text1, '') AS LifeStage,
    tp.preparations AS preparations,
    co.altCatalogNumber AS OtherCatalogNumbers,
    coa.text7 AS associatedMedia,
    ce.collectingeventid AS samplescollectingeventid,
    co.collectionobjectid AS samplescollectionobjectid,
    co.collectionid AS internalCollectionID                 
FROM Zoologia.collectionobject co
    INNER JOIN Zoologia.collectingevent ce
        ON co.collectingeventid = ce.collectingeventid
    LEFT JOIN Zoologia.collectionobjectattribute coa
        ON co.collectionobjectattributeid = coa.collectionobjectattributeid
    LEFT JOIN dwc.ZOOtempPreparation tp
        ON co.collectionobjectid = tp.collectionobjectid
WHERE co.restrictions = 'publico' AND co.collectionID = 65537
GROUP BY ce.collectingeventid;

ALTER TABLE `dwc`.`ZOOsamplesDC` ADD PRIMARY KEY (`catalogNumber`)
, ENGINE = InnoDB;

/*
Identification
identificationID | identifiedBy | dateIdentified | identificationReferences | identificationRemarks | identificationQualifier | typeStatus

    * IdentificationID
    * IdentifiedBy
    * DateIdentified
    * IdentificationReferences
    * IdentificationRemarks
    * PreviousIdentifications
    * IdentificationQualifier
    * TypeStatus


*/

DROP TABLE IF EXISTS dwc.ZOOidentificationDC;

CREATE TABLE dwc.ZOOidentificationDC
SELECT
    d.determinationid AS identificationID,
    CONCAT(a.lastname, ', ',a.abbreviation) AS identifiedBy,
    CASE d.determineddateprecision
        WHEN 1 THEN
            (d.determineddate )
        WHEN 2 THEN
            (LEFT(d.determineddate, 7) )
        WHEN 3 THEN
            (year(d.determineddate) )
    END AS dateIdentified,
    d.remarks AS identificationRemarks,
    d.qualifier AS identificationQualifier,
    d.typestatusname AS typeStatus,
    d.collectionobjectID,
    d.taxonID AS IdentificationTaxonID,
    d.PreferredTaxonID
FROM Zoologia.determination d LEFT JOIN Zoologia.agent a ON d.determinerid = a.agentid
WHERE d.isCurrent = 1;

ALTER TABLE `dwc`.`ZOOidentificationDC` ADD PRIMARY KEY (`identificationID`)
, ENGINE = InnoDB;


-- query final para juntar tabelas

DROP TABLE IF EXISTS dwc.ZOOsimpleDarwinCore;

CREATE TABLE dwc.ZOOsimpleDarwinCore
SELECT distinct * from dwc.ZOOsamplesDC s
    INNER JOIN dwc.ZOOidentificationDC i on s.samplescollectionobjectid = i.collectionobjectid
    INNER JOIN dwc.ZOOsamplingeventDC se on s.samplescollectingeventid = se.samplingeventid
    INNER JOIN dwc.ZOOlocationDC l on se.samplingeventid = l.collectingeventid
    INNER JOIN dwc.ZOOtaxonDC t on i.preferredtaxonid = t.taxonid;

ALTER TABLE `dwc`.`ZOOsimpleDarwinCore` ADD PRIMARY KEY (`collectionID`)
, ENGINE = InnoDB;

ALTER TABLE `dwc`.`ZOOsimpleDarwinCore` MODIFY COLUMN `dateIdentified` DATETIME  DEFAULT NULL;

ALTER TABLE `dwc`.`ZOOsimpleDarwinCore` MODIFY COLUMN `EarliestDateCollected` DATETIME  DEFAULT NULL;

UPDATE dwc.ZOOsimpleDarwinCore SET earliestdatecollected = NULL WHERE earliestdatecollected = '0000-00-00 00:00:00';

UPDATE dwc.ZOOsimpleDarwinCore SET dateidentified = NULL WHERE dateidentified = '0000-00-00 00:00:00';

UPDATE dwc.ZOOsimpleDarwinCore SET kingdom = 'Animalia'  WHERE kingdom LIKE 'CZ %';

UPDATE dwc.ZOOsimpleDarwinCore SET phylum = 'Chordata'  WHERE phylum LIKE 'CZ %';

UPDATE dwc.ZOOsimpleDarwinCore SET class = 'Aves'  WHERE class LIKE 'CZ %' AND InternalCollectionID = 4;

UPDATE dwc.ZOOsimpleDarwinCore SET class = 'Mammalia'  WHERE class LIKE 'CZ %' AND InternalCollectionID = 32769;

UPDATE dwc.ZOOsimpleDarwinCore SET `order` = NULL  WHERE `order` like 'CZ %';

UPDATE dwc.ZOOsimpleDarwinCore SET family = NULL  WHERE family like 'CZ %';

update dwc.ZOOsimpleDarwinCore set verbatimLocality = replace(verbatimLocality, '\t', '');

update dwc.ZOOsimpleDarwinCore set verbatimLocality = replace(verbatimLocality, '\n', '');

update dwc.ZOOsimpleDarwinCore set locality = replace(locality, '\t', '');

update dwc.ZOOsimpleDarwinCore set locality = replace(locality, '\n', '');

update dwc.ZOOsimpleDarwinCore set ScientificNameAuthorship = replace(ScientificNameAuthorship, '\t', '');
update dwc.ZOOsimpleDarwinCore set ScientificNameAuthorship = replace(ScientificNameAuthorship, '\n', '');

/*

Query final para colocar em IPT

SELECT InstitutionCode, CollectionCode, collectionID, BasisOfRecord, catalogNumber,
sampleRemarks, ReproductiveCondition, preparations, OtherCatalogNumbers,
associatedMedia, samplescollectingeventid, samplescollectionobjectid, identificationID,
identifiedBy, dateIdentified, identificationRemarks, identificationQualifier,
typeStatus, collectionobjectID, IdentificationTaxonID, PreferredTaxonID, SamplingEventID,
VerbatimCollectingDate, EarliestDateCollected, YearSampled, MonthOfYear, DayOfMonth,
Collector, CollectorNumber, SamplingEventRemarks, Continent, Country, CountryCode,
StateProvince, County, SamplingLocationID, locality, VerbatimLocality, VerbatimElevation,
MinimumElevationInMeters, MaximumElevationInMeters, DecimalLatitude, DecimalLongitude,
GeodeticDatum, CoordinatePrecision, SamplingLocationRemarks, collectingeventid, TaxonID,
ScientificName, binomial, Kingdom, family, genus, specificEpithet, TaxonRank,
InfraspecificEpithet, ScientificNameAuthorship, TaxonomicStatus, AcceptedTaxonID,
AcceptedTaxon FROM simpleDarwinCoreAVES

helper queries

SELECT
  CASE determineddateprecision
     WHEN 1 THEN
      ( d.determineddate )
    WHEN 2 THEN
      ( LEFT(d.determineddate, 7) )
    WHEN 3 THEN
      ( year(d.determineddate) )
  END
  as dateIdentified
FROM determination

SELECT L.`InstitutionCode`, L.`CollectionCode`, L.`collectionID`, L.`BasisOfRecord`, L.`catalogNumber`, L.`sex`, L.`LifeStage`, L.`preparations`, L.`OtherCatalogNumbers`, L.`identifiedBy`, L.`dateIdentified`, L.`identificationQualifier`, L.`typeStatus`, L.`VerbatimCollectingDate`, L.`EarliestDateCollected`, L.`YearSampled`, L.`MonthOfYear`, L.`DayOfMonth`, L.`Collector`, L.`CollectorNumber`, L.`Continent`, L.`Country`, L.`CountryCode`, L.`StateProvince`, L.`County`, L.`locality`, L.`VerbatimLocality`, L.`VerbatimElevation`, L.`MinimumElevationInMeters`, L.`MaximumElevationInMeters`, L.`DecimalLatitude`, L.`DecimalLongitude`, L.`GeodeticDatum`, L.`CoordinatePrecision`, L.`ScientificName`, L.`binomial`, L.`Kingdom`, L.`phylum`, L.`class`, L.`order`, L.`family`, L.`genus`, L.`specificEpithet`, L.`TaxonRank`, L.`InfraspecificEpithet`, L.`ScientificNameAuthorship`, L.`TaxonomicStatus`, L.`AcceptedTaxon` INTO OUTFILE '/tmp/zooOufile2.file' FIELDS TERMINATED BY '\t' FROM ZOOsimpleDarwinCore L where country IS NOT NULL;

InstitutionCode    CollectionCode    collectionID    BasisOfRecord    catalogNumber    sex    LifeStage    preparations    OtherCatalogNumbers    identifiedBy    dateIdentified    identificationQualifier    typeStatus    VerbatimCollectingDate    EarliestDateCollected    YearSampled    MonthOfYear    DayOfMonth    Collector    CollectorNumber    Continent    Country    CountryCode    StateProvince    County    locality    VerbatimLocality    VerbatimElevation    MinimumElevationInMeters    MaximumElevationInMeters    DecimalLatitude    DecimalLongitude    GeodeticDatum    CoordinatePrecision    ScientificName    binomial    Kingdom    phylum    class    order    family    genus    specificEpithet    TaxonRank    InfraspecificEpithet    ScientificNameAuthorship    TaxonomicStatus    AcceptedTaxon
*/

