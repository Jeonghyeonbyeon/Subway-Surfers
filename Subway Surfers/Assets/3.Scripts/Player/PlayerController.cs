using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    [SerializeField] private float playerSpeed;
    private Rigidbody playerRigid;
    private Animator animator;

    private void Init()
    {
        playerRigid = GetComponent<Rigidbody>();
        animator = GetComponent<Animator>();
    }

    private void Start() => Init();

    private void Update()
    { 
        float x = Input.GetAxisRaw("Horizontal");
        float y = Input.GetAxisRaw("Vertical");

        transform.Translate(x * playerSpeed * Time.deltaTime, (y == 0 ? 0 : -1) * playerSpeed * Time.deltaTime, 0f);

        if (Physics.Raycast(transform.position + Vector3.up * 0.25f, Vector3.down, out RaycastHit hit, 0.25f, LayerMask.GetMask("Ground"))) animator.Play("Run");
        
        else animator.Play("Jump");
        
        OnDrawRay();
    }

    private void OnJump()
    {
        if (Physics.Raycast(transform.position + Vector3.up * 0.25f, Vector3.down, out RaycastHit hit, 0.25f, LayerMask.GetMask("Ground")))
        {
            playerRigid.velocity = Vector3.up * 8.5f;
        }
    }

    private void OnDrawRay()
    {
        Debug.DrawRay(transform.position, Vector3.down * 0.25f, new Color(0, 1, 0));
    }
}
