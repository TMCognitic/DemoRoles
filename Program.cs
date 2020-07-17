using Microsoft.VisualBasic.CompilerServices;
using System;
using System.Data;
using System.Data.SqlClient;

namespace DemoRoles
{
    class Program
    {
        static void Main(string[] args)
        {
            using (SqlConnection sqlConnection = new SqlConnection())
            {
                sqlConnection.ConnectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=TestUsers;Integrated Security=True;";

                using(SqlCommand sqlCommand = sqlConnection.CreateCommand())
                {
                    sqlCommand.CommandText = "CheckUser";
                    sqlCommand.CommandType = CommandType.StoredProcedure;
                    sqlCommand.Parameters.AddWithValue("Email", "thierry.morre@cognitic.be");
                    sqlCommand.Parameters.AddWithValue("Passwd", "Test1234=");

                    sqlConnection.Open();
                    using(SqlDataReader reader = sqlCommand.ExecuteReader())
                    {
                        if(reader.HasRows)
                        {
                            reader.Read();
                            User user = new User() { Id = (int)reader["Id"], Nom = (string)reader["Nom"], Prenom = (string)reader["Prenom"], Email = (string)reader["Email"], Roles = (Roles)reader["Roles"] };

                            Console.WriteLine($"{user.Nom} {user.Prenom} : {user.Roles}");

                            if(user.Roles.HasFlag(Roles.Client))
                            {
                                Console.WriteLine("Je suis un client");
                            }

                            if (user.Roles.HasFlag(Roles.Livreur))
                            {
                                Console.WriteLine("Je suis un livreur");
                            }

                            if (user.Roles.HasFlag(Roles.Maraicher))
                            {
                                Console.WriteLine("Je suis un maraîcher");
                            }

                            if (user.Roles.HasFlag(Roles.Admin))
                            {
                                Console.WriteLine("Je suis un admin");
                            }
                        }
                        else
                        {
                            Console.WriteLine("Erreur login ou mot de passe");
                        }
                    }
                }
            }
        }
    }

    [Flags]
    enum Roles
    {
        Client = 1,
        Livreur = 2,
        Maraicher = 4,
        Admin = 8,
        SuperAdmin = 16
    }

    class User
    {
        public int Id { get; set; }
        public string Nom { get; set; }
        public string Prenom { get; set; }
        public string Email { get; set; }
        public Roles Roles { get; set; }
    }
}
