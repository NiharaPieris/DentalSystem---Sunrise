<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.sunrise.dental.util.DBConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sunrise Dental Clinic - Your Smile, Our Care</title>

    <!-- Bootstrap 5 + Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        :root {
            --primary: #0d6efd;
            --primary-dark: #0b5ed7;
            --dark: #1a1a2e;
        }

        body {
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            color: #333;
        }

        /* Navbar */
        .navbar {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            box-shadow: 0 2px 20px rgba(0,0,0,0.08);
            padding: 0.8rem 0;
        }
        .navbar-brand {
            font-weight: 700;
            font-size: 1.4rem;
            color: var(--primary) !important;
        }
        .nav-link {
            font-weight: 500;
            color: #444 !important;
            margin: 0 0.4rem;
        }
        .nav-link:hover {
            color: var(--primary) !important;
        }

        /* Hero */
        .hero {
            background: linear-gradient(135deg, #0d6efd 0%, #0b5ed7 50%, #084298 100%);
            color: white;
            padding: 120px 0 100px;
            position: relative;
            overflow: hidden;
        }
        .hero::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -20%;
            width: 600px;
            height: 600px;
            background: rgba(255,255,255,0.05);
            border-radius: 50%;
        }
        .hero h1 {
            font-size: 3rem;
            font-weight: 700;
            line-height: 1.2;
        }
        .hero .lead {
            font-size: 1.2rem;
            opacity: 0.9;
        }

        /* Sections */
        .section {
            padding: 80px 0;
        }
        .section-title {
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        .section-subtitle {
            color: #6c757d;
            margin-bottom: 3rem;
        }

        /* Cards */
        .feature-card, .treatment-card, .dentist-card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.07);
            transition: all 0.3s ease;
            height: 100%;
            background: white;
        }
        .feature-card:hover, .treatment-card:hover, .dentist-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 30px rgba(0,0,0,0.12);
        }

        .treatment-card .card-img-top {
            height: 160px;
            background: linear-gradient(135deg, #e3f2fd, #bbdefb);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            color: var(--primary);
            border-radius: 16px 16px 0 0;
        }

        .dentist-avatar {
            width: 90px;
            height: 90px;
            border-radius: 50%;
            background: linear-gradient(135deg, #0d6efd, #0b5ed7);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.2rem;
            margin: 0 auto 1rem;
        }

        .cost-tag {
            background: #e8f5e9;
            color: #2e7d32;
            font-weight: 600;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.9rem;
        }

        /* Why Choose Us */
        .why-item {
            text-align: center;
            padding: 1.5rem;
        }
        .why-icon {
            width: 70px;
            height: 70px;
            border-radius: 16px;
            background: #e3f2fd;
            color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            margin: 0 auto 1rem;
        }

        /* Contact */
        .contact-info i {
            color: var(--primary);
            font-size: 1.3rem;
            width: 30px;
        }

        /* Footer */
        footer {
            background: var(--dark);
            color: #ccc;
            padding: 50px 0 25px;
        }
        footer a {
            color: #aaa;
            text-decoration: none;
        }
        footer a:hover {
            color: white;
        }
        footer h5 {
            color: white;
            font-weight: 600;
        }

        .btn-primary {
            border-radius: 10px;
            font-weight: 500;
            padding: 0.6rem 1.4rem;
        }
        .btn-outline-light {
            border-radius: 10px;
            font-weight: 500;
            padding: 0.6rem 1.4rem;
        }
    </style>
</head>
<body>

<!-- ===================== NAVBAR ===================== -->
<nav class="navbar navbar-expand-lg sticky-top">
    <div class="container">
        <a class="navbar-brand" href="<%= request.getContextPath() %>/jsp/home.jsp">
            <i class="bi bi-hospital me-2"></i>Sunrise Dental
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto align-items-center">
                <li class="nav-item"><a class="nav-link" href="#home">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="#about">About</a></li>
                <li class="nav-item"><a class="nav-link" href="#treatments">Treatments</a></li>
                <li class="nav-item"><a class="nav-link" href="#dentists">Dentists</a></li>
                <li class="nav-item"><a class="nav-link" href="#contact">Contact</a></li>
                <li class="nav-item ms-2">
                    <a class="btn btn-primary btn-sm" href="<%= request.getContextPath() %>/jsp/login.jsp">
                        <i class="bi bi-box-arrow-in-right me-1"></i> Login
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- ===================== HERO ===================== -->
<section class="hero" id="home">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-lg-7">
                <h1 class="mb-3">Your Smile,<br>Our Priority</h1>
                <p class="lead mb-4">
                    Experience professional dental care with modern technology,
                    experienced dentists, and a warm, patient-focused approach.
                </p>
                <div class="d-flex flex-wrap gap-3">
                    <a href="#treatments" class="btn btn-light btn-lg text-primary fw-semibold">
                        <i class="bi bi-calendar2-plus me-2"></i>Book Appointment
                    </a>
                    <a href="<%= request.getContextPath() %>/jsp/login.jsp" class="btn btn-outline-light btn-lg">
                        Staff Login
                    </a>
                </div>
            </div>
            <div class="col-lg-5 d-none d-lg-block text-center">
                <i class="bi bi-emoji-smile" style="font-size: 12rem; opacity: 0.15;"></i>
            </div>
        </div>
    </div>
</section>

<!-- ===================== ABOUT ===================== -->
<section class="section bg-white" id="about">
    <div class="container">
        <div class="text-center mb-5">
            <h2 class="section-title">About Sunrise Dental Clinic</h2>
            <p class="section-subtitle">Caring for smiles since day one</p>
        </div>
        <div class="row align-items-center g-5">
            <div class="col-lg-6">
                <p class="mb-4">
                    At Sunrise Dental Clinic, we believe everyone deserves a healthy, confident smile.
                    Our team of qualified dentists and caring staff provide comprehensive dental care
                    in a comfortable and modern environment.
                </p>
                <div class="row g-3">
                    <div class="col-sm-6">
                        <div class="d-flex align-items-start gap-3">
                            <i class="bi bi-bullseye text-primary fs-4"></i>
                            <div>
                                <h6 class="fw-bold mb-1">Our Mission</h6>
                                <small class="text-muted">Deliver quality dental care that is accessible, affordable and patient-centered.</small>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-6">
                        <div class="d-flex align-items-start gap-3">
                            <i class="bi bi-eye text-primary fs-4"></i>
                            <div>
                                <h6 class="fw-bold mb-1">Our Vision</h6>
                                <small class="text-muted">Healthy smiles through innovation, trust and continuous care.</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-6">
                <div class="row g-3">
                    <div class="col-6">
                        <div class="feature-card p-4 text-center">
                            <i class="bi bi-people fs-2 text-primary mb-2"></i>
                            <h4 class="fw-bold mb-0">500+</h4>
                            <small class="text-muted">Happy Patients</small>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="feature-card p-4 text-center">
                            <i class="bi bi-person-badge fs-2 text-primary mb-2"></i>
                            <h4 class="fw-bold mb-0">10+</h4>
                            <small class="text-muted">Expert Dentists</small>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="feature-card p-4 text-center">
                            <i class="bi bi-heart-pulse fs-2 text-primary mb-2"></i>
                            <h4 class="fw-bold mb-0">20+</h4>
                            <small class="text-muted">Treatments</small>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="feature-card p-4 text-center">
                            <i class="bi bi-star fs-2 text-primary mb-2"></i>
                            <h4 class="fw-bold mb-0">4.9</h4>
                            <small class="text-muted">Patient Rating</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ===================== TREATMENTS ===================== -->
<section class="section" id="treatments" style="background: #f8f9fa;">
    <div class="container">
        <div class="text-center mb-5">
            <h2 class="section-title">Our Treatments</h2>
            <p class="section-subtitle">Professional care tailored to your needs</p>
        </div>

        <div class="row g-4">
            <%
                try (Connection conn = DBConnection.getConnection();
                     Statement st = conn.createStatement();
                     ResultSet rs = st.executeQuery(
                             "SELECT * FROM treatments WHERE active = TRUE ORDER BY name")) {

                    boolean hasData = false;
                    while (rs.next()) {
                        hasData = true;
                        int tid = rs.getInt("treatment_id");
                        String name = rs.getString("name");
                        String desc = rs.getString("description") != null ? rs.getString("description") : "";
                        int duration = rs.getInt("duration_minutes");
                        String cost = rs.getBigDecimal("cost").toString();
            %>
            <div class="col-md-6 col-lg-4">
                <div class="treatment-card">
                    <div class="card-img-top">
                        <i class="bi bi-heart-pulse"></i>
                    </div>
                    <div class="card-body p-4">
                        <h5 class="fw-bold mb-2"><%= name %></h5>
                        <p class="text-muted small mb-3">
                            <%= desc.length() > 90 ? desc.substring(0, 90) + "..." : desc %>
                        </p>
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <small class="text-muted">
                                <i class="bi bi-clock me-1"></i><%= duration %> min
                            </small>
                            <span class="cost-tag">Rs. <%= cost %></span>
                        </div>
                        <a href="<%= request.getContextPath() %>/jsp/makeAppointment.jsp?treatment_id=<%= tid %>"
                           class="btn btn-primary w-100">
                            <i class="bi bi-calendar-plus me-1"></i> Book Now
                        </a>
                    </div>
                </div>
            </div>
            <%
                }
                if (!hasData) {
            %>
            <div class="col-12 text-center text-muted py-5">
                <i class="bi bi-info-circle fs-3 d-block mb-2"></i>
                No treatments available at the moment.
            </div>
            <%
                }
            } catch (Exception e) {
            %>
            <div class="col-12 text-center text-danger">
                Unable to load treatments.
            </div>
            <% } %>
        </div>
    </div>
</section>

<!-- ===================== DENTISTS ===================== -->
<section class="section bg-white" id="dentists">
    <div class="container">
        <div class="text-center mb-5">
            <h2 class="section-title">Meet Our Dentists</h2>
            <p class="section-subtitle">Experienced professionals dedicated to your care</p>
        </div>

        <div class="row g-4 justify-content-center">
            <%
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement(
                             "SELECT * FROM users WHERE role = 'Dentist' AND active = TRUE");
                     ResultSet rs = ps.executeQuery()) {

                    boolean hasData = false;
                    while (rs.next()) {
                        hasData = true;
                        String name = rs.getString("username");
                        String specialization = rs.getString("specialization") != null ? rs.getString("specialization") : "General Dentistry";
                        String email = rs.getString("email");
                        String phone = rs.getString("phone") != null ? rs.getString("phone") : "";
            %>
            <div class="col-md-6 col-lg-4">
                <div class="dentist-card p-4 text-center">
                    <div class="dentist-avatar">
                        <i class="bi bi-person"></i>
                    </div>
                    <h5 class="fw-bold mb-1"><%= name %></h5>
                    <p class="text-primary small mb-2"><%= specialization %></p>
                    <p class="text-muted small mb-1">
                        <i class="bi bi-envelope me-1"></i><%= email %>
                    </p>
                    <% if (!phone.isEmpty()) { %>
                    <p class="text-muted small mb-0">
                        <i class="bi bi-telephone me-1"></i><%= phone %>
                    </p>
                    <% } %>
                </div>
            </div>
            <%
                }
                if (!hasData) {
            %>
            <div class="col-12 text-center text-muted">
                No dentists listed at the moment.
            </div>
            <%
                }
            } catch (Exception e) {
            %>
            <div class="col-12 text-center text-danger">Unable to load dentists.</div>
            <% } %>
        </div>
    </div>
</section>

<!-- ===================== WHY CHOOSE US ===================== -->
<section class="section" style="background: #f8f9fa;" id="why">
    <div class="container">
        <div class="text-center mb-5">
            <h2 class="section-title">Why Choose Us</h2>
            <p class="section-subtitle">What makes Sunrise Dental different</p>
        </div>
        <div class="row g-4">
            <div class="col-md-4">
                <div class="why-item">
                    <div class="why-icon"><i class="bi bi-person-check"></i></div>
                    <h5 class="fw-bold">Qualified Dentists</h5>
                    <p class="text-muted small">Experienced and certified professionals focused on your comfort and results.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="why-item">
                    <div class="why-icon"><i class="bi bi-calendar-check"></i></div>
                    <h5 class="fw-bold">Easy Booking</h5>
                    <p class="text-muted small">Book your appointment online in just a few clicks — quick and convenient.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="why-item">
                    <div class="why-icon"><i class="bi bi-shield-check"></i></div>
                    <h5 class="fw-bold">Secure Records</h5>
                    <p class="text-muted small">Your personal and medical information is kept safe and confidential.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="why-item">
                    <div class="why-icon"><i class="bi bi-heart"></i></div>
                    <h5 class="fw-bold">Patient-Centered</h5>
                    <p class="text-muted small">We listen, explain, and care — every treatment is tailored to you.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="why-item">
                    <div class="why-icon"><i class="bi bi-receipt"></i></div>
                    <h5 class="fw-bold">Clear Billing</h5>
                    <p class="text-muted small">Transparent pricing with no hidden charges. Know exactly what you pay.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="why-item">
                    <div class="why-icon"><i class="bi bi-clock-history"></i></div>
                    <h5 class="fw-bold">Flexible Hours</h5>
                    <p class="text-muted small">Open Monday to Saturday so you can visit at a time that suits you.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ===================== CONTACT ===================== -->
<section class="section bg-white" id="contact">
    <div class="container">
        <div class="text-center mb-5">
            <h2 class="section-title">Contact Us</h2>
            <p class="section-subtitle">We’d love to hear from you</p>
        </div>
        <div class="row g-4 justify-content-center">
            <div class="col-md-8">
                <div class="card border-0 shadow-sm rounded-4 p-4">
                    <div class="row g-4">
                        <div class="col-md-6">
                            <div class="d-flex gap-3 mb-4">
                                <i class="bi bi-geo-alt-fill contact-info"></i>
                                <div>
                                    <h6 class="fw-bold mb-1">Address</h6>
                                    <p class="text-muted mb-0 small">123 Main Street, Ratnapura,<br>Sri Lanka</p>
                                </div>
                            </div>
                            <div class="d-flex gap-3 mb-4">
                                <i class="bi bi-telephone-fill contact-info"></i>
                                <div>
                                    <h6 class="fw-bold mb-1">Phone</h6>
                                    <p class="text-muted mb-0 small">+94 71 234 5678</p>
                                </div>
                            </div>
                            <div class="d-flex gap-3 mb-4">
                                <i class="bi bi-envelope-fill contact-info"></i>
                                <div>
                                    <h6 class="fw-bold mb-1">Email</h6>
                                    <p class="text-muted mb-0 small">info@sunrisedental.com</p>
                                </div>
                            </div>
                            <div class="d-flex gap-3">
                                <i class="bi bi-clock-fill contact-info"></i>
                                <div>
                                    <h6 class="fw-bold mb-1">Opening Hours</h6>
                                    <p class="text-muted mb-0 small">Mon – Sat: 9:00 AM – 7:00 PM<br>Sunday: Closed</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6 d-flex align-items-center justify-content-center">
                            <div class="text-center">
                                <i class="bi bi-hospital text-primary" style="font-size: 5rem; opacity: 0.15;"></i>
                                <p class="text-muted mt-3 mb-0">Visit us for a healthier smile</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ===================== FOOTER ===================== -->
<footer>
    <div class="container">
        <div class="row g-4">
            <div class="col-md-4">
                <h5 class="mb-3">
                    <i class="bi bi-hospital me-2"></i>Sunrise Dental
                </h5>
                <p class="small">Professional dental care with a personal touch. Your smile is our greatest reward.</p>
            </div>
            <div class="col-md-4">
                <h5 class="mb-3">Quick Links</h5>
                <ul class="list-unstyled small">
                    <li class="mb-2"><a href="#about">About Us</a></li>
                    <li class="mb-2"><a href="#treatments">Treatments</a></li>
                    <li class="mb-2"><a href="#dentists">Our Dentists</a></li>
                    <li class="mb-2"><a href="#contact">Contact</a></li>
                    <li><a href="<%= request.getContextPath() %>/jsp/login.jsp">Staff Login</a></li>
                </ul>
            </div>
            <div class="col-md-4">
                <h5 class="mb-3">Contact</h5>
                <p class="small mb-1"><i class="bi bi-geo-alt me-2"></i>123 Main Street, Ratnapura</p>
                <p class="small mb-1"><i class="bi bi-telephone me-2"></i>+94 71 234 5678</p>
                <p class="small"><i class="bi bi-envelope me-2"></i>info@sunrisedental.com</p>
            </div>
        </div>
        <hr class="border-secondary my-4">
        <div class="text-center small">
            &copy; 2026 Sunrise Dental Clinic. All rights reserved.
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>