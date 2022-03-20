using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using projetoCompany.Models;

namespace projetoCompany.Controllers
{
    public class AlunoController : Controller
    {
        // GET: Aluno
       
        public ActionResult Index()
        {
            string email = (string)Session["email"];
            ViewData["listaDeCertificados"] = ListarCertificados(email);
            return View();
        }

        [HttpPost]
        public ActionResult Validar(Aluno login, string returnUrl)
        {
            if (!ModelState.IsValid)
            {
                return View(login);
            }
            var achou = ValidarUsuario(login.alunoEmail, login.alunoSenha);

            if (achou)
            {
                FormsAuthentication.SetAuthCookie(login.alunoEmail, login.LembrarMe);
                Session["email"] = login.alunoEmail;
                return RedirectToAction("Index");
            }
            
            achou = ValidarProf(login.alunoEmail, login.alunoSenha);
            if (achou) {

                FormsAuthentication.SetAuthCookie(login.alunoEmail, login.LembrarMe);
                Session["email"] = login.alunoEmail;
                return RedirectToAction("Index","Professor");

            }
            //se não achou o login, ou seja, se não existir é enviado uma mensagem
            else
            {
                ModelState.AddModelError("", "Login Inválido");
                return RedirectToAction("Index", "Home");
            }

            
        }

        public static bool ValidarUsuario(string AlunoEmail, string alunoSenha)
        {
            bool ret;
            using (var conexao = new SqlConnection())
            {
                conexao.ConnectionString = ConfigurationManager.ConnectionStrings["CONEXAO"].ToString(); 
                conexao.Open();
                using (var comando = new SqlCommand())
                {
                    comando.Connection = conexao;
                    comando.CommandText = string.Format(
                        "select count (*) from Aluno where email ='{0}' and senha ='{1}'", AlunoEmail, alunoSenha);
                    ret = ((int)comando.ExecuteScalar() > 0);
                }

            }
            return ret;

        }

        public static bool ValidarProf(string profEmail, string profSenha)
        {
            bool ret;
            using (var conexao = new SqlConnection())
            {
                conexao.ConnectionString = ConfigurationManager.ConnectionStrings["CONEXAO"].ToString();
                conexao.Open();
                using (var comando = new SqlCommand())
                {
                    comando.Connection = conexao;
                    comando.CommandText = string.Format(
                        "select count (*) from Professor where emailProf ='{0}' and senhaProf ='{1}'", profEmail, profSenha);
                    ret = ((int)comando.ExecuteScalar() > 0);
                }

            }
            return ret;

        }

        public List<Certificados> ListarCertificados(string email)
        {

            conexaoBD();
            con.Open();
            SqlCommand cmd = new SqlCommand("ConsultarCertificados", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@email", email);
            List<Certificados> placa = new List<Certificados>();

            SqlDataReader dr = cmd.ExecuteReader();

            while (dr.Read())
            {
                placa.Add(new Certificados
                {
                    nomeCertificado = (string)dr["nomeCertificado"],
                    tipoCertificado=(string)dr["tipoCertificado"],
                    horas = (int)Convert.ToInt32(dr["horasCertificado"]),
                    homologacao=(string)dr["homologacao"]
                });
            }

            con.Close();

            return placa;
        }

        public ActionResult UploadArquivo(string nomeCertificado, string tipoCertificado, string horasCertificado, byte[] pdf)
        {
            conexaoBD();
            con.Open();
            SqlCommand cmd = new SqlCommand("adicionarCertificado", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@nomeCertificado", nomeCertificado);
            cmd.Parameters.AddWithValue("@tipoCertificado", tipoCertificado);
            cmd.Parameters.AddWithValue("@horasCertificado", horasCertificado);  
            cmd.Parameters.AddWithValue("@pdf", pdf);  
            cmd.Parameters.AddWithValue("@email", (string)Session["email"]);           

            SqlDataReader dr = cmd.ExecuteReader();

            con.Close();

            return RedirectToAction("Index");           

        }

        public JsonResult UploadPdf()
        {
            string path = "c:\\Universidade\\Certificados";
            HttpFileCollectionBase files = Request.Files;
            string[] values = Request.Form.GetValues("tipoCertificado");
            string[] valuesHora = Request.Form.GetValues("horasCertificado");
            string Usuario = Session["email"].ToString();

            HttpPostedFileBase file = files[0];
            string tipoCert = values[0];
            string horaCert = valuesHora[0];


            byte[] binaryData;
            binaryData = new byte[file.InputStream.Length];
            file.InputStream.Read(binaryData, 0, (int)file.InputStream.Length);
            file.InputStream.Close();
            // string base64 = Convert.ToBase64String(binaryData, 0, binaryData.Length);



            //  string NumeroTRRV = nTrav.Replace("/", "_");
            var Ano = DateTime.Now.Year;
            var Mes = DateTime.Now.Month;
            var Dia = DateTime.Now.Day;
            var Valor = DateTime.Now.Millisecond;
            string pasta = path + @"\" + Ano + @"\" + Usuario + @"\";
            string Nome = "Certificado_" + tipoCert + "_" + Dia + "-" + Mes + "-" + Ano + "__" + Valor + ".pdf";
            path = pasta + Nome;

            if (!Directory.Exists(pasta))
            {
                Directory.CreateDirectory(pasta);
            }
            try
            {
                System.IO.File.WriteAllBytes(path, binaryData);


                // Salva os anexos no banco  [Stb_veiculo_Anexo_Insercao_UpdateWEB]

                // Ocorrencia.inserirFormulario(versaoFormulario, nTrav, binaryData);
                UploadArquivo(Nome,tipoCert,horaCert,binaryData);

                return Json(files.Count + "Sucesso", JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { Resultado = ex.Message, error = true }, JsonRequestBehavior.AllowGet);
            }
        }




        private SqlConnection con;
        private void conexaoBD() {
            string constr = ConfigurationManager.ConnectionStrings["CONEXAO"].ToString();
            con = new SqlConnection(constr);

        }

    }
}