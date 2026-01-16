DROP DATABASE IF EXISTS StudentManagement;
CREATE DATABASE session15_test;
USE session15_test;

-- =============================================
-- 1. TABLE STRUCTURE
-- =============================================

-- Table: Students
CREATE TABLE Students (
    StudentID CHAR(5) PRIMARY KEY,
    FullName VARCHAR(50) NOT NULL,
    TotalDebt DECIMAL(10,2) DEFAULT 0
);

-- Table: Subjects
CREATE TABLE Subjects (
    SubjectID CHAR(5) PRIMARY KEY,
    SubjectName VARCHAR(50) NOT NULL,
    Credits INT CHECK (Credits > 0)
);

-- Table: Grades
CREATE TABLE Grades (
    StudentID CHAR(5),
    SubjectID CHAR(5),
    Score DECIMAL(4,2) CHECK (Score BETWEEN 0 AND 10),
    PRIMARY KEY (StudentID, SubjectID),
    CONSTRAINT FK_Grades_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    CONSTRAINT FK_Grades_Subjects FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID)
);

-- Table: GradeLog
CREATE TABLE GradeLog (
    LogID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID CHAR(5),
    OldScore DECIMAL(4,2),
    NewScore DECIMAL(4,2),
    ChangeDate DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- 2. SEED DATA
-- =============================================

-- Insert Students
INSERT INTO Students (StudentID, FullName, TotalDebt) VALUES 
('SV01', 'Ho Khanh Linh', 5000000),
('SV03', 'Tran Thi Khanh Huyen', 0);

-- Insert Subjects
INSERT INTO Subjects (SubjectID, SubjectName, Credits) VALUES 
('SB01', 'Co so du lieu', 3),
('SB02', 'Lap trinh Java', 4),
('SB03', 'Lap trinh C', 3);

-- Insert Grades
INSERT INTO Grades (StudentID, SubjectID, Score) VALUES 
('SV01', 'SB01', 8.5), -- Passed
('SV03', 'SB02', 3.0); -- Failed


-- Phần A
-- Câu 1 :

-- Trigger kiểm tra hợp lệ score
delimiter //
create trigger tg_CheckScore 
before insert on grades
for each row
begin
	if new.Score < 0 then
		set new.score = 0;
    end if;
    if new.Score > 10 then
		set new.score = 10;
	end if;
end //

drop trigger tg_CheckScore;

-- Test không hợp lệ câu 1
insert into grades(StudentID, SubjectID, Score)
values ('SV01', 'SB02', -5);


-- Câu 2
-- Thêm mới sinh viên dùng transaction
start transaction;

insert into Students (StudentID, FullName)
values ('SV02', 'Ha Bich Ngoc');

update Students
set TotalDebt = 5000000
where StudentID = 'SV02';

commit;


-- Phần B
-- Câu 3
-- Trigger log cập nhật
delimiter //
create trigger tg_LogGradeUpdate  
after update on grades
for each row
begin
	insert into gradelog(StudentID,OldScore,NewScore,ChangeDate)
    value (old.StudentID , old.Score , new.Score , now());
end //

-- test trigger 
update grades
set Score = 10
where StudentID = 'SV03';

-- Câu 4
delimiter //
create procedure sp_PayTuition(p_StudentID varchar(5) , p_cost decimal(10,2))
begin
	declare v_TotalDebt decimal(10,2);

	start transaction;
    update students
    set TotalDebt = TotalDebt - p_cost
    where StudentID = p_StudentID;
    
    select TotalDebt into v_TotalDebt from students where StudentID = p_StudentID;
    
    if v_TotalDebt < 0 then
		rollback;
	end if;
    commit;
end //

drop procedure sp_PayTuition;

-- Test
call sp_PayTuition('SV01',2000000);

-- Câu 5
delimiter //
create trigger tg_PreventPassUpdate
before update on Grades
for each row
begin
    if old.Score >= 4.0 then
        signal sqlstate '45000'
        set message_text = 'Sinh viên đã qua môn, không được phép sửa điểm';
    end if;
end //

-- Test sinh viên đã qua môn
update grades
set Score = 9.0
where StudentID = 'SV01' and SubjectID = 'SB02';

-- Test sinh viên chưa qua môn
insert into grades(StudentID, SubjectID, Score)
values ('SV01', 'SB03', 2.5);

update grades
set Score = 3.5
where StudentID = 'SV01' and SubjectID = 'SB03';



-- Câu 6
delimiter //
create procedure sp_DeleteStudentGrade( p_StudentID char(5), p_SubjectID char(5))
begin
    declare v_OldScore decimal(4,2);
    
    start transaction;

    select Score into v_OldScore
    from grades
    where StudentID = p_StudentID
      and SubjectID = p_SubjectID;

    insert into GradeLog(StudentID, OldScore, NewScore, ChangeDate)
    values (p_StudentID, v_OldScore, null, now());

    delete from grades
    where StudentID = p_StudentID
      and SubjectID = p_SubjectID;

    if row_count() = 0 then
        rollback;
        signal sqlstate '45000' set message_text = 'Không tìm thấy môn học';
    else
        commit;
    end if;
end //

drop procedure sp_DeleteStudentGrade;
	
    
-- Test xóa môn học tồn tại
call sp_DeleteStudentGrade('SV01', 'SB03');

-- Test xóa môn không tồn tại
call sp_DeleteStudentGrade('SV01', 'SB99');












