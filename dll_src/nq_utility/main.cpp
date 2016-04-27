#include "win32.h"
#include <chrono>
#include <string>
#include <memory.h>
#include <random>
#include <map>

#undef min
#undef max

template <typename T>
class UniformRealDistribution
{
public:
	typedef T result_type;
	UniformRealDistribution(T _a = 0.0, T _b = 1.0) : m_a(_a), m_b(_b) {}
	void reset() {}

	template <class Generator>
	T operator()(Generator &_g)
	{
		double dScale = (m_b - m_a) / ( (T) (_g.max() - _g.min()) + (T) 1); 
		return (_g() - _g.min()) * dScale  + m_a;
	}

	T a() const {return m_a;}
	T b() const {return m_b;}
protected:
	T m_a;
	T m_b;
};

template <typename T>
class NormalDistribution
{
public:
	typedef T result_type;
	NormalDistribution(T _mean = 0.0, T _stddev = 1.0) : m_mean(_mean), m_stddev(_stddev) {}
	void reset()
	{
		m_distU1.reset();
	}

	template <class Generator> T operator()(Generator &_g)
	{
		// Use Box-Muller algorithm
		const double pi = 3.14159265358979323846264338327950288419716939937511;
		double u1 = m_distU1(_g);
		double u2 = m_distU1(_g);
		double r = sqrt(-2.0 * log(u1));
		return (m_mean + m_stddev * r * sin(2.0 * pi * u2));
	}

	T mean() const {return m_mean;}
	T stddev() const {return m_stddev;}

protected:
	T m_mean;
	T m_stddev;
	UniformRealDistribution<T>  m_distU1;
};

long long lastUniqueID = 0;
std::map<unsigned int, std::mt19937*> randomGenerators;

std::mt19937* getRandomGenerator(unsigned int i)
{
	if (!randomGenerators.count(i))					{ randomGenerators[i] = new std::mt19937((unsigned int) std::chrono::system_clock::now().time_since_epoch().count()); }

	return randomGenerators[i];
}

void destroyRandomGenerator(unsigned int i)
{
	if (randomGenerators.count(i))
	{
		delete randomGenerators[i];

		randomGenerators.erase(randomGenerators.find(i));
	}
}

extern "C" EXPORT char *getUniqueID(int n, char *v[])
{
	if (lastUniqueID == 0)
	{
		std::chrono::milliseconds ms				= std::chrono::duration_cast<std::chrono::milliseconds>(std::chrono::system_clock::now().time_since_epoch());
		lastUniqueID = ms.count();
	}

	long long id									= ++lastUniqueID;

	std::string str									= std::to_string(id);

	char* buf										= new char[str.size() + 1];
	memcpy(buf, str.c_str(), str.size());
	buf[str.size()]									= 0;
	
	return buf;
}

extern "C" EXPORT char *setRandSeed(int n, char *v[])
{
	if (n == 2)
	{
		std::mt19937* random						= getRandomGenerator(atoi(v[0]));
		unsigned long seed							= strtoul(v[1], NULL, 0);

		random->seed(seed);

		return (char*) "0";
	}
	else											{ return (char*) "1"; }
}

extern "C" EXPORT char *getRandomNumber(int n, char *v[])
{
	if (n == 4)
	{
		std::mt19937* random						= getRandomGenerator(atoi(v[0]));
		
		double low									= atof(v[1]);
		double high									= atof(v[2]);
		unsigned int max_decimals					= atoi(v[3]);

		UniformRealDistribution<double> dist(0, high - low);

		double result								= (double) dist(*random);

		result										= result + low;

		int r										= 10 * max_decimals;

		if (r > 0)									{ result = round(result * r) / r; }
		else										{ result = round(result); }

		char* buf									= new char[32];

		doubleToChar(result, buf, 32);

		return buf;
	}
	else											{ return (char*) ""; }
}

extern "C" EXPORT char *destroyRandomGenerator(int n, char *v[])
{
	if (n == 1)										{ destroyRandomGenerator(atoi(v[0])); }

	return (char*) ""; 
}
