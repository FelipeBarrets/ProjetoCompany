using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using projetoCompany.Models;

namespace projetoCompany.Controllers
{
    public class ProfessorController : Controller
    {

        private SqlConnection con;
        private void conexaoBD()
        {
            string constr = ConfigurationManager.ConnectionStrings["CONEXAO"].ToString();
            con = new SqlConnection(constr);

        }
        // GET: Professor
        public ActionResult Index(string msg)
        {
            if (msg != "") {
                ViewBag.msg = msg;
            }
            string email = (string)Session["email"];
            ViewData["listarCertificados"] = ListarTodosCertificados();
            ViewData["listarAlunos"] = ListarAlunos();

            return View();
        }

        public List<Aluno> ListarTodosCertificados()
        {

            List<Aluno> TodosCertificados = new List<Aluno>();
            conexaoBD();
            con.Open();
            SqlCommand cmd = new SqlCommand("listarCertificados", con);
            cmd.CommandType = CommandType.StoredProcedure;
            

            SqlDataReader dr = cmd.ExecuteReader();

            while (dr.Read())
            {
                Aluno aluno = new Aluno();

                try { aluno.alunoEmail = (string)dr["email"]; } catch { aluno.alunoEmail = ""; };
                try { aluno.nomeCertificado = (string)dr["nomeCertificado"]; } catch { aluno.nomeCertificado = "";};
                TodosCertificados.Add(aluno);
            }
            
            con.Close();

            return TodosCertificados;
        }
        public ActionResult adicionarAluno(string alunoEmail,string alunoSenha)
        {        
                        
            conexaoBD();
            con.Open();
            SqlCommand cmd = new SqlCommand("adicionarAluno", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@email", alunoEmail);
            cmd.Parameters.AddWithValue("@senha", alunoSenha);
            List<Aluno> alunos= new List<Aluno>();

            SqlDataReader dr = cmd.ExecuteReader();
           

            con.Close();

            return RedirectToAction("Index", new { msg="Cadastro Concluido"});
        }
        public List<Aluno> ListarAlunos()
        {

            conexaoBD();
            con.Open();
            SqlCommand cmd = new SqlCommand("listarAlunos", con);
            cmd.CommandType = CommandType.StoredProcedure;
            List<Aluno> alunos= new List<Aluno>();

            SqlDataReader dr = cmd.ExecuteReader();

            while (dr.Read())
            {
                alunos.Add(new Aluno
                {
                    alunoEmail = (string)dr["email"]
                });
            }

            con.Close();

            return alunos;
        }

        

    }
}