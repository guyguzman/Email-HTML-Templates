[BindProperty] public string CustomerName { get; set; }
        [BindProperty] public string CustomerOwnerNameFirst { get; set; }
        [BindProperty] public string CustomerOwnerNameLast { get; set; }
        [BindProperty] public string CustomerEmail { get; set; }
        [BindProperty] public string CustomerLine1 { get; set; }
        [BindProperty] public string CustomerCity { get; set; }
        [BindProperty] public string CustomerState { get; set; }
        [BindProperty] public string CustomerZipCode { get; set; }
        [BindProperty] public string OwnerId { get; set; }


            public JsonResult OnPostAddCustomer()
        {
            Stripe.Customer customer = new Stripe.Customer();
            Stripe.AddressOptions addressOptions = new Stripe.AddressOptions();

            var temp = OwnerId;

            addressOptions.Line1 = CustomerLine1;
            addressOptions.City = CustomerCity;
            addressOptions.PostalCode = CustomerZipCode;
            addressOptions.State = CustomerState;

            CustomerCreateOptions options = new CustomerCreateOptions
            {
                Description = CustomerName,
                Email = CustomerEmail,
                Name = CustomerName,
                Address = addressOptions,
                Metadata = new Dictionary<string, string>
                {
                    { "OwnerID", OwnerId },
                },
            };

            CustomerService service = new CustomerService();
            Stripe.Customer result = service.Create(options);
            System.Diagnostics.Debug.Write(result);

            return new JsonResult(result.Id);
            //return Content("Success");
        }

              public IActionResult SaveCoreClientToCookie()
        {
            string cookieSession = HttpContext.Request.Cookies[".AspNetCore.Session"];
            string cookieAzureADB2C = HttpContext.Request.Cookies[".AspNetCore.AzureADB2CCookie"];
            string sessionIdString = HttpContext.Session.Id;
            Guid sessionIdGuid = Guid.Parse(sessionIdString);

            //Response.Cookies.Delete(".AspNetCore.Session");

            CoreClient coreClient = new CoreClient();
            coreClient.IpAddress = IpAddress;
            coreClient.IpCity = IpCity;
            coreClient.IpState = IpState;
            coreClient.IpPostal = IpPostal;
            coreClient.IpOrg = IpOrg;

            try
            {
                coreClient.IpLatitude = Convert.ToDecimal(IpLatitude);
            }
            catch
            {
                coreClient.IpLatitude = 0M;
            }

            try
            {
                coreClient.IpLongitude = Convert.ToDecimal(IpLongitude);
            }
            catch
            {
                coreClient.IpLatitude = 0M;
            }

            coreClient.ScreenWidth = ScreenWidth;
            coreClient.ScreenHeight = ScreenHeight;
            coreClient.ViewportWidth = ViewportWidth;
            coreClient.ViewportHeight = ViewportHeight;

            logger.LogInformation("Cookie Contents coreClient {@CoreClient}", coreClient);

            Response.Cookies.Delete("CoreClient");
            CookieOptions option = new CookieOptions
            {
                //Expires = DateTime.Now.AddMinutes(60),
                //IsEssential = true,
                Secure = true,
                HttpOnly = true,
                SameSite = SameSiteMode.None
            };

            try
            {
                Response.Cookies.Append("key", "value", option);
                Response.Cookies.Append("CoreClient", Newtonsoft.Json.JsonConvert.SerializeObject(coreClient), option);
            }
            catch (Exception e)
            {
                logger.LogError("Saving Cookie Error {@eMessage}", e.Message);
            }

            return Page();
        }