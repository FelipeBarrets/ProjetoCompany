using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace projetoCompany.Models
{
    public class Aluno
    {
                
        public string alunoEmail { get; set; }

        public string alunoSenha { get; set; }

        public bool LembrarMe { get; set; }

        public string nomeCertificado { get; set; }

        

    }

    public class Certificados
    {
        public string nomeCertificado { get; set; }

        public string tipoCertificado { get; set; }

        public string homologacao { get; set; }

        public int horas { get; set; }


    }


}