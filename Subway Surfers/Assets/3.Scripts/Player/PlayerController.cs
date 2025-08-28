using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    [SerializeField] private float speed;
    [SerializeField] private float jumpPower;
    [SerializeField] private LayerMask layerMask;
    private int playerPos = 0;
    private Rigidbody rb;
    private Animator anim;

    private void Init()
    {
        rb = GetComponent<Rigidbody>();
        anim = GetComponent<Animator>();
    }

    private void Start() => Init();

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.A)) playerPos -= 1;
        if (Input.GetKeyDown(KeyCode.D)) playerPos += 1;

        playerPos = Mathf.Clamp(playerPos, -1, 1);

        if (Physics.Raycast(transform.position + Vector3.up * 1.5f, Vector3.down, out RaycastHit hit, 3f, layerMask)) anim.Play("Run");
        
        else anim.Play("Jump");
        
        OnDrawRay();
    }

    private void FixedUpdate() => transform.position = new Vector3(Mathf.Lerp(transform.position.x, playerPos * 6, 0.1f), transform.position.y, transform.position.z);

    private void OnJump()
    {
        if (Physics.Raycast(transform.position + Vector3.up * 1.5f, Vector3.down, out RaycastHit hitInfo, 3f, layerMask))
        {
            rb.velocity = Vector3.up * jumpPower;
        }
    }

    private void OnDrawRay() => Debug.DrawRay(transform.position + Vector3.up * 1.5f, Vector3.down * 3f, new Color(0, 1, 0));
}
