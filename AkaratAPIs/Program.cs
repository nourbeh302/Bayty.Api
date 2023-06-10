using EF_Modeling;
using EF_Modeling.DataStore;
using FluentValidation.AspNetCore;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Models.DataStoreContract;
using Models.Entities;
using System.Text;
using AkaratAPIs.Validators;
using AkaratAPIs.Middlewares;
using AqaratAPIs.Services.Authentication;
using AqaratAPIs.Services.EmailSending;
using AqaratAPIs.Services.RealTime;
using AqaratAPIs.Services.SMS;
using Newtonsoft.Json;
using AqaratAPIs.Profiles;
using BaytyAPIs.Services.PropertyFactory;
using BaytyAPIs.Security.AddPostSecurityRequirements;
using Microsoft.AspNetCore.Authorization;
//Brain tree Payment Service Handler
var builder = WebApplication.CreateBuilder(args);

//builder.Logging.ClearProviders();

//var logger = new LoggerConfiguration()
//    .MinimumLevel.Debug()
//    .WriteTo.File($"./Logs/LogDay{Convert.ToString(DateTime.Now)}/Test.txt", LogEventLevel.Debug, rollingInterval: RollingInterval.Day)
//    .CreateLogger();

// Add services to the container.


builder.Services.AddControllers()
                .AddNewtonsoftJson(opts =>
                {
                    opts.SerializerSettings.ReferenceLoopHandling = ReferenceLoopHandling.Ignore;
                })
                .AddFluentValidation(config => config.RegisterValidatorsFromAssemblies(ValidatorsAssembliesList.validatorsAssembly));


// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();

builder.Services.AddAutoMapper(config => config.AddProfile<AdProfile>());

builder.Services.AddSwaggerGen();

builder.Services.Configure<JWT>(builder.Configuration.GetSection("JWT"));

builder.Services.Configure<SMSSettings>(builder.Configuration.GetSection("SMSSettings"));

builder.Services.Configure<MailSettings>(builder.Configuration.GetSection("MailSettings"));

builder.Services.AddSingleton<IPropertyFactory, PropertyFactory>();

builder.Services.AddIdentity<User, IdentityRole>(opts => opts.User.AllowedUserNameCharacters += " ")
                .AddDefaultTokenProviders()
                .AddEntityFrameworkStores<AppDbContext>();

////Liftetime => notfound
builder.Services.AddDbContextPool<AppDbContext>(opts =>
{
          opts.UseSqlServer(builder.Configuration["ConnectionStrings:DefaultConnection"],
        a => a.MigrationsAssembly(typeof(AppDbContext).Assembly.FullName))
              .UseQueryTrackingBehavior(QueryTrackingBehavior.NoTracking);
});

builder.Services.AddSingleton<PhoneNumberValidatorTokens>();

builder.Services.AddSingleton<IWebSocketService, WebSocketService>();

builder.Services.AddScoped<IDataStore, DataStore>();

builder.Services.AddScoped<IAuthService, AuthService>();

builder.Services.AddScoped<IEmailSenderService, EmailSenderService>();

builder.Services.AddScoped<ISMSService, SMSService>();

builder.Services.AddHttpClient<ISMSService, SMSService>();

builder.Services.AddAuthorization(config =>
{
    config.AddPolicy("EmailVerifiedPolicy", config => config.RequireClaim("EmailVerified", "True"));
    config.AddPolicy("Add-Post",            config => config.AddRequirements(new AddPostRequirement()));
});

builder.Services.AddScoped<IAuthorizationHandler, AddPostHandler>();

builder.Services.AddAuthentication(opts =>
{
    opts.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    opts.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
    .AddJwtBearer(opts =>
    {
        opts.SaveToken = false;
        opts.RequireHttpsMetadata = false; // In Production will be true
        opts.TokenValidationParameters = new TokenValidationParameters
        {
            ClockSkew = TimeSpan.Zero,
            ValidateIssuerSigningKey = true,
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidIssuer = builder.Configuration["JWT:Issuer"],
            ValidAudience = builder.Configuration["JWT:Audience"],
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(builder.Configuration["JWT:Key"]!))
        };
    });

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

//Http Request

app.UseStaticFiles();

app.UseWebSockets();

app.UseExceptionHandler("/Error");

app.UseHttpsRedirection();

app.UseCors(config =>
{
    config.AllowAnyHeader()
          .AllowAnyMethod()
          .AllowAnyOrigin();
});

app.UseRefreshTokenHandler();

app.UseAuthentication();

app.UseAuthorization();

app.MapControllers();

app.Run();