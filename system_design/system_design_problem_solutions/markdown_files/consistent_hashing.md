### Consistent Hashing

Image - 001

![consistent-hashing-1](../images/consistent_hashing/1.png)

Image - 002

![consistent-hashing-2](../images/consistent_hashing/2.png)

Image - 003

![consistent-hashing-3](../images/consistent_hashing/3.png)

Image - 004

![consistent-hashing-4](../images/consistent_hashing/4.png)

Image - 005

![consistent-hashing-5](../images/consistent_hashing/5.png)

Image - 006

![consistent-hashing-6](../images/consistent_hashing/6.png)

Image - 007

![consistent-hashing-7](../images/consistent_hashing/7.png)

Image - 008

![consistent-hashing-8](../images/consistent_hashing/8.png)

Image - 009

![consistent-hashing-9](../images/consistent_hashing/9.png)

Image - 010

![consistent-hashing-10](../images/consistent_hashing/10.png)

Image - 011

![consistent-hashing-11](../images/consistent_hashing/11.png)

Image - 012

![consistent-hashing-12](../images/consistent_hashing/12.png)

Image - 013

![consistent-hashing-13](../images/consistent_hashing/13.png)


### Consistent hashing - Mathematical Guarantee

Consistent hashing does come with mathematical guarantees about how keys are distributed, though the guarantees depend on which variant of consistent hashing is used and what assumptions you make about the hash function. Let me break it down clearly:

⸻

1. Classic Consistent Hashing (Karger et al., 1997)
	•	Setup: Servers (or “buckets”) and keys are placed on a unit circle using a uniform hash function.
	•	Guarantee:
	•	If the hash function is truly uniform and independent, then the expected number of keys per server is proportional to its fraction of the circle length.
	•	The load imbalance (the maximum deviation from uniform distribution) is about O(\log N / N) for N servers, with high probability.
	•	More precisely: for n keys and N servers, each server gets about n/N keys in expectation, and with high probability no server gets more than O((n/N) \cdot \log N).
	•	Problem: With a small number of servers, variance is high (some servers may get large ranges). To smooth this out, virtual nodes (each server appears multiple times on the circle) are used.

⸻

2. Consistent Hashing with Virtual Nodes
	•	If each physical server has O(\log N) virtual nodes, the distribution of keys to servers becomes balanced with high probability:
	•	Each server gets at most a constant factor more than the average number of keys.
	•	Specifically, if each server has m virtual nodes and m = O(\log N), then the maximum load per server is (1 + \epsilon) \cdot (n/N) for small \epsilon, with high probability.

⸻

3. Modern Variants with Stronger Guarantees

Several later works improved the theoretical bounds:
	•	Balanced Allocations (“Power of Two Choices”):
Instead of mapping each key to one location, map it to two (or more) candidate servers and pick the less loaded. This gives much tighter bounds — maximum load is about n/N + O(\log \log N).
	•	Consistent Hashing with Bounded Loads (Mirrokni, Thorup, 2018):
Provides a scheme where no server exceeds a fixed multiple (say 1+\epsilon) of the average load, with high probability, even under churn.

⸻

4. Key Takeaway Guarantees
	•	Uniformity (Expectation): Each server gets ~equal share of keys.
	•	Balance (High Probability): With virtual nodes or bounded-load schemes, the maximum load per server is very close to the average (n/N).
	•	Stability: When adding/removing a server, only O(n/N) keys need to be moved, not O(n).