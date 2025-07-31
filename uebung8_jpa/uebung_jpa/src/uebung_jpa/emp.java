package uebung_jpa;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "EMP")
public class emp {

    @Id
    @Column(name = "EMPNO")
    private int empno;

    @Column(name = "ENAME")
    private String ename;

    @Column(name = "JOB")
    private String job;

    @Column(name = "MGR")
    private Integer mgr;

    @Temporal(TemporalType.DATE)
    @Column(name = "HIREDATE")
    private Date hiredate;

    @Column(name = "SAL")
    private double sal;

    @Column(name = "COMM")
    private double comm;

    @Column(name = "DEPTNO")
    private int deptno;

    // Standard-Konstruktor
    public Emp() {}

    // Getter und Setter
    public int getEmpno() { return empno; }
    public void setEmpno(int empno) { this.empno = empno; }

    public String getEname() { return ename; }
    public void setEname(String ename) { this.ename = ename; }

    public String getJob() { return job; }
    public void setJob(String job) { this.job = job; }

    public Integer getMgr() { return mgr; }
    public void setMgr(Integer mgr) { this.mgr = mgr; }

    public Date getHiredate() { return hiredate; }
    public void setHiredate(Date hiredate) { this.hiredate = hiredate; }

    public double getSal() { return sal; }
    public void setSal(double sal) { this.sal = sal; }

    public double getComm() { return comm; }
    public void setComm(double comm) { this.comm = comm; }

    public int getDeptno() { return deptno; }
    public void setDeptno(int deptno) { this.deptno = deptno; }
}
