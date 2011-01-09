Name:           nagios-plugins-rabbitmq
Version:        1.0
Release:        1%{?dist}
Summary:        Nagios checks for RabbitMQ

Group:          Development/Libraries
License:        APL2
URL:            https://github.com/jamesc/nagios-plugins-rabbitmq
Source0:        nagios-plugins-rabbitmq-%{version}.tar.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

BuildArch:     noarch
# Correct for lots of packages, other common choices include eg. Module::Build
BuildRequires:  perl(Module::Build)
Requires:  perl(:MODULE_COMPAT_%(eval "`%{__perl} -V:version`"; echo $version))

%{?perl_default_filter}

%description
Nagios checks for RabbitMQ messaging server.

These use the RabbitMQ management interface for gathering various
information about the server

%prep
%setup -q


%build
# Remove OPTIMIZE=... from noarch packages (unneeded)
%{__perl} Build.PL --installdirs=vendor OPTIMIZE="$RPM_OPT_FLAGS"
Build %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
Build pure_install --destdir=$RPM_BUILD_ROOT
find $RPM_BUILD_ROOT -type f -name .packlist -exec rm -f {} ';'
# Remove the next line from noarch packages (unneeded)
find $RPM_BUILD_ROOT -depth -type d -exec rmdir {} 2>/dev/null ';'
%{_fixperms} $RPM_BUILD_ROOT/*


%check
make test


%clean
rm -rf $RPM_BUILD_ROOT


%files
%defattr(-,root,root,-)
%doc LICENCE.txt README.md
%{bindir}/*
%{_mandir}/man1/*.1*


%changelog
